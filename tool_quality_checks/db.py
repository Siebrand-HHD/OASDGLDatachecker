# (c) Nelen & Schuurmans.  GPL licensed, see LICENSE.rst.
# -*- coding: utf-8 -*-
import os
import psycopg2
import logging

OUR_DIR = os.path.dirname(__file__)
logger = logging.getLogger(__name__)


def _connect_to_server(settings, sql_statement):
    """ Establishes the db connection. """
    credentials = {
        "host": settings.host,
        "user": settings.username,
        "password": settings.password,
    }

    try:
        conn = psycopg2.connect(**credentials)
        conn.autocommit = True
        cursor = conn.cursor()
        cursor.execute(sql_statement)
        conn.close()
        print("test)")
    except psycopg2.Error as e:
        logger.exception(e)
        raise


def drop_database(settings):
    """drops a database"""
    drop_database_statement = """DROP DATABASE IF EXISTS {database_name};""".format(
        database_name=settings.database
    )
    _connect_to_server(settings, drop_database_statement)


def create_database(settings):
    """create a database"""
    create_database_statement = """
    CREATE DATABASE {database_name}
    ;""".format(
        database_name=settings.database
    )
    _connect_to_server(settings, create_database_statement)


class ThreediDatabase(object):
    """
    Connects to a database using python's psycopg2 module.
    """

    def __init__(self, settings):
        """ Establishes the db connection. """
        credentials = {
            "dbname": settings.database,
            "host": settings.host,
            "user": settings.username,
            "password": settings.password,
        }
        try:
            self.conn = psycopg2.connect(**credentials)
        except psycopg2.Error as e:
            logger.exception(e)
            raise

    def create_extension(self, extension_name):
        """create a extension"""
        create_extension_statement = """
        CREATE EXTENSION IF NOT EXISTS {extension_name}
        ;""".format(
            extension_name=extension_name
        )
        self.execute_sql_statement(
            sql_statement=create_extension_statement, fetch=False
        )

    def initialize_db_threedi(self):
        """ Initialize database for threedi """
        self.create_extension(extension_name="postgis")
        sql_relpath = os.path.join(
            "threedi_database_schema", "work_empty_schema_2020-01-15.sql"
        )
        sql_abspath = os.path.join(os.path.abspath(OUR_DIR), sql_relpath)
        self.execute_sql_file(sql_abspath)

    def get_count(self, table_name, schema="public"):
        """
        :param table:
        :return:
        """
        statement = "SELECT COUNT(*) from {schema}.{table_name:s}".format(
            table_name=table_name, schema=schema
        )
        result = self.execute_sql_statement(statement, fetch=True)
        return result[0][0]

    def execute_sql_statement(self, sql_statement, fetch=True):
        """
        :param sql_statement: custom sql statement

        makes use of the existing database connection to run a custom query
        """
        with self.conn:
            with self.conn.cursor() as cur:
                cur.execute(sql_statement)
                logger.debug(
                    "[+] Successfully executed statement {}".format(sql_statement)
                )
                if fetch is True:
                    return cur.fetchall()

    def select_table_names(self, search_table_name, schema="public"):

        statement = """
        SELECT table_name
        FROM   information_schema.tables
        WHERE  table_schema = '{schema}'
        AND    table_name LIKE '{search_table_name}'
        AND    table_type = 'BASE TABLE';
        """.format(
            schema=schema, search_table_name=search_table_name
        )
        return [i[0] for i in self.execute_sql_statement(statement, fetch=True)]

    def create_schema(self, schema_name, drop_schema=False):
        """create a schema"""
        if drop_schema == True:
            drop_schema = """DROP SCHEMA IF EXISTS {schema_name} CASCADE;""".format(
                schema_name=schema_name
            )
            self.execute_sql_statement(drop_schema, fetch=False)
        create_schema_statement = """
        CREATE SCHEMA IF NOT EXISTS {schema_name}
        ;""".format(
            schema_name=schema_name
        )
        self.execute_sql_statement(sql_statement=create_schema_statement, fetch=False)

    def create_preset_view_from_dictionary(
        self, view_dictionary, view_table, view_schema, drop_view=True
    ):
        """
        Drop and create a view from a dictionary
        """
        if drop_view:
            drop_statement = """DROP VIEW IF EXISTS {view_schema}.{view_table};""".format(
                view_table=view_table, view_schema=view_schema
            )
            self.execute_sql_statement(drop_statement, fetch=False)
        create_statement = view_dictionary[view_table].format(schema=view_schema)
        self.execute_sql_statement(sql_statement=create_statement, fetch=False)

    def populate_geometry_columns(self):
        """Populate geometry columns"""
        populate_geometry_columns_statement = """
        SELECT Populate_Geometry_Columns();"""
        self.execute_sql_statement(
            sql_statement=populate_geometry_columns_statement, fetch=False
        )

    def create_table(self, table_name, field_names, field_types, schema="public"):
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

        if not table_name:
            raise ValueError("[E] table_name {} is not defined".format(table_name))

        row_def_raw = []
        for field_name, field_type in zip(field_names, field_types):
            s = "%s %s" % (field_name, field_type)
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
        self.execute_sql_statement(del_str, fetch=False)
        self.execute_sql_statement(create_str, fetch=False)
        logger.info("[+] Successfully created table {}.{}".format(schema, table_name))

    def execute_sql_file(self, filename):
        # Open and read the file as a single buffer
        # OCL: problemen met het openen van de file: https://github.com/python-pillow/Pillow/issues/477
        with open(filename, "r") as f:
            sql_file = f.read()
        # sql_file = open(filename, "r").read()
        self.execute_sql_statement(sql_statement=sql_file, fetch=False)
        logger.debug("Execute sql file with function:" + filename)

    def commit_values(self, table_name, field_names, data, schema="public"):
        """
        :param table_name: destination table
        :param field_names: field names that correspond with the
            data array
        :param data: array of tuples with data to insert
        """

        records_list_template = ",".join(["%s"] * len(data))
        insert_query = """
        INSERT INTO
            {schema}.{table_name}({field_names})
        VALUES
            {template}""".format(
            schema=schema,
            table_name=table_name,
            field_names=field_names,
            template=records_list_template,
        )
        with self.conn:
            with self.conn.cursor() as cur:
                cur.execute(insert_query, data)

    def empty_database(self):
        sql_abspath = os.path.join(OUR_DIR, "sql", "sql_empty_3di_database.sql")
        self.execute_sql_file(sql_abspath)
