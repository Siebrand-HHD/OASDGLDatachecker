# (c) Nelen & Schuurmans.  GPL licensed, see LICENSE.rst.
# -*- coding: utf-8 -*-

import psycopg2
import logging

log = logging.getLogger(__name__)


class ThreediDatabase(object):
    """
    Connects to a database using python's psycopg2 module.
    """

    def __init__(self, settings):
        """
        Establishes the db connection.
        """
        credentials = {
            "dbname": settings.database,
            "host": settings.host,
            "user": settings.username,
            "password": settings.password,
        }
        try:
            self.db = psycopg2.connect(**credentials)
        except psycopg2.Error as e:
            log.exception(e)
            raise
