# (c) Nelen & Schuurmans.  GPL licensed, see LICENSE.rst.
# -*- coding: utf-8 -*-

import psycopg2

# from psycopg2.extras import RealDictCursor
import logging
import sql

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
            drop_schema = """DROP SCHEMA IF EXISTS {schema_name};""".format(
                schema_name=schema_name
            )
            self.free_form(drop_schema, fetch=False)
        create_schema_statement = """
        CREATE SCHEMA IF NOT EXISTS {schema_name}
        ;""".format(
            schema_name=schema_name
        )
        self.free_form(sql_statement=create_schema_statement, fetch=False)

    def populate_geometry_columns(self):
        """Populate geometry columns"""
        populate_geometry_columns_statement = """
        SELECT Populate_Geometry_Columns();"""
        self.free_form(sql_statement=populate_geometry_columns_statement, fetch=False)

    def perform_checks_with_sql(self, check_table, check_type):
        """
        Performs quality checks on postgres DB

        :param check_table - list of one or more structure tables (e.g. v2_manhole)
        :param check_type - select type of check: completeness, quality

        """
        check_table = check_table.strip("v2_")
        sql_template_name = "sql_" + check_type + "_" + check_table
        if sql_template_name in sql.sql_checks:
            statement = sql.sql_checks[sql_template_name]
            self.free_form(sql_statement=statement, fetch=False)
