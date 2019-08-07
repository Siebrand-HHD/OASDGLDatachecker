# (c) Nelen & Schuurmans.  GPL licensed, see LICENSE.rst.
# -*- coding: utf-8 -*-
""" TODO Docstring. """

import psycopg2

# from psycopg2.extras import RealDictCursor
import logging
import sql_checks
import sql_views
import os

logger = logging.getLogger(__name__)

DEFAULT_FETCH = "default"


class ThreediDatabase(object):
    """
    Connects to a database using python's psycopg2 module.
    """

    def __init__(self, settings):
        """
        Establishes the db connection.
        """
        # could be made variable
        self.schema = "public"
        credentials = {
            "dbname": settings.database,
            "host": settings.host,
            "user": settings.username,
            "password": settings.password,
        }
        try:
            self.db = psycopg2.connect(**credentials)
        except psycopg2.Error as e:
            logger.exception(e)
            raise

    def initialize_db(self):
        """
            initialize database for checks
        """
        self.create_schema(schema_name="chk")
        self.create_schema(schema_name="src")
        for view_table in [
            ["public", "v2_1d_boundary_conditions_view"],
            ["public", "v2_pumpstation_point_view"],
            ["public", "v2_1d_lateral_view"],
            ["public", "v2_cross_section_definition_rio_view"],
            ["chk", "v2_pipe_view_left_join"],
            ["chk", "v2_orifice_view_left_join"],
            ["chk", "v2_weir_view_left_join"],
        ]:
            self.create_view(view_table=view_table[1], view_schema=view_table[0])

        # install all function out of folder "sql_functions"
        sql_reldir = "sql_functions"
        sql_absdir = os.path.join(os.path.dirname(__file__), sql_reldir)
        self.execute_sql_dir(sql_absdir)

    def get_count(self, table_name):
        """
        :param table:
        :return:
        """
        statement = "SELECT COUNT(*) from {schema}.{table_name:s}".format(
            table_name=table_name, schema=self.schema
        )
        result = self.free_form(statement, fetch=True)
        return result[0][0]

    def _get_cursor(self, user_choise=""):
        # if user_choise == 'dict':
        #    return self.db.cursor(cursor_factory=RealDictCursor)
        # else:
        return self.db.cursor()

    def _raise(self, _exception):
        if self.db:
            self.db.rollback()
        logger.error("Error %s" % _exception)
        raise

    def free_form(self, sql_statement, fetch=True, fetch_as=DEFAULT_FETCH):
        """
        :param sql_statement: custom sql statement

        makes use of the existing database connection to run a custom query
        """

        try:
            cur = self._get_cursor(fetch_as)
            cur.execute(sql_statement)
            self.db.commit()
            logger.debug("[+] Successfully executed statement {}".format(sql_statement))
            if fetch is True:
                return cur.fetchall()

        except psycopg2.DatabaseError as e:
            self._raise(e)

    def select_table_names(self, search_table_name, schema=None):
        schema = schema or self.schema

        statement = """
        SELECT table_name
        FROM   information_schema.tables
        WHERE  table_schema = '{schema}'
        AND    table_name LIKE '{search_table_name}'
        AND    table_type = 'BASE TABLE';
        """.format(
            schema=schema, search_table_name=search_table_name
        )
        return [i[0] for i in self.free_form(statement, fetch=True)]

    def create_schema(self, schema_name, drop_schema=False):
        """create a schema"""
        if drop_schema == True:
            drop_schema = """DROP SCHEMA IF EXISTS {schema_name} CASCADE;""".format(
                schema_name=schema_name
            )
            self.free_form(drop_schema, fetch=False)
        create_schema_statement = """
        CREATE SCHEMA IF NOT EXISTS {schema_name}
        ;""".format(
            schema_name=schema_name
        )
        self.free_form(sql_statement=create_schema_statement, fetch=False)

    def create_table(self, table_name, field_names, field_types, schema=None):
        """
        :param table_name: string that will be used as a name in the database.
        :param field_names: list of field names to add to the tables
        :param field_types: list of field types

        example::
            create_table(
                "my_table", ["foo", "bar", "my_double"],
                ["serial", "smallint", "double precision"]
            )
        """

        schema = schema or self.schema

        if not table_name:
            raise ValueError("[E] table_name {} is not definied".format(table_name))

        row_def_raw = []
        for e, ee in zip(field_names, field_types):
            s = "%s %s" % (e, ee)
            row_def_raw.append(s)

        row_def = ",".join(row_def_raw)
        create_str = """
            CREATE TABLE
              {schema}.{table_name}
            (id serial PRIMARY KEY,{row_definition})
            ;
            """.format(
            schema=schema, table_name=table_name, row_definition=row_def
        )

        del_str = "DROP TABLE IF EXISTS %s.%s;" % (schema, table_name)
        self.free_form(del_str, fetch=False)
        self.free_form(create_str, fetch=False)
        logger.info("[+] Successfully created table {}.{}".format(schema, table_name))

    def create_view(self, view_table, view_schema, drop_view=True):
        """
        Creates a view with a join to v2_connection_nodes table
        
        :param view_table - table of which the view is created
        """
        if drop_view == True:
            drop_statement = """DROP VIEW IF EXISTS {view_table};""".format(
                view_table=view_table
            )
            self.free_form(drop_statement, fetch=False)
        create_statement = sql_views.sql_views[view_table].format(schema=view_schema)
        self.free_form(sql_statement=create_statement, fetch=False)

    def populate_geometry_columns(self):
        """Populate geometry columns"""
        populate_geometry_columns_statement = """
        SELECT Populate_Geometry_Columns();"""
        self.free_form(sql_statement=populate_geometry_columns_statement, fetch=False)

    def perform_checks_with_sql(self, settings, check_table, check_type):
        """
        Performs quality checks on postgres DB

        :param check_table - list of one or more structure tables (e.g. v2_manhole)
        :param check_type - select type of check: completeness, quality
        """
        check_table = check_table.replace("v2_", "")
        sql_template_name = "sql_" + check_type + "_" + check_table
        if sql_template_name in sql_checks.sql_checks:
            statement = sql_checks.sql_checks[sql_template_name].format(
                **settings.__dict__
            )
            self.free_form(sql_statement=statement, fetch=False)

    def execute_sql_file(self, filename):
        # Open and read the file as a single buffer
        fd = open(filename, "r")
        sql_file = fd.read()
        fd.close()

        self.free_form(sql_statement=sql_file, fetch=False)
        logger.info("Execute sql file with function:" + filename)

    def execute_sql_dir(self, dirname):
        for root, subdirs, files in sorted(os.walk(dirname)):
            for f in sorted(files):
                file_path = root + "/" + f
                if file_path.endswith(".sql"):
                    self.execute_sql_file(file_path)
