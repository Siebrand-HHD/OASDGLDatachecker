# (c) Nelen & Schuurmans.  GPL licensed, see LICENSE.rst.
# -*- coding: utf-8 -*-

import psycopg2
import logging

logger = logging.getLogger(__name__)

DEFAULT_FETCH = 'default'

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

    def get_count(self, table_name):
        """
        :param table:
        :return:
        """
        try:
            cur = self._get_cursor()
            sel_str = "SELECT COUNT(*) from {schema}.{table_name:s}".format(
                table_name=table_name, schema=self.schema
            )
            logger.debug(sel_str)
            cur.execute(sel_str)
            return cur.fetchone()[0]

        except psycopg2.DatabaseError as e:
            self._raise(e)

    def _get_cursor(self, user_choise=""):
        if user_choise == 'dict':
            return self.db.cursor(cursor_factory=RealDictCursor)
        else:
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
            logger.debug(
                "[+] Successfully executed statement {}".format(
                    sql_statement)
            )
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
        AND    table_name LIKE '{search_table_name}';
        """.format(schema=schema, search_table_name=search_table_name)
        return [i[0] for i in self.free_form(statement, fetch=True)]
