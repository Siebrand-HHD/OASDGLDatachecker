# -*- coding: utf-8 -*-
"""Tests for db.py"""
import os
import pytest

from OASDGLDatachecker.tool_quality_checks.scripts import SettingsObject
from OASDGLDatachecker.tool_quality_checks.db import (
    ThreediDatabase,
    create_database,
    drop_database,
)
from OASDGLDatachecker.tool_quality_checks.sql_views import sql_views

from unittest import TestCase

OUR_DIR = os.path.dirname(__file__)
_ini_relpath = "data/instellingen_test.ini"
INI_ABSPATH = os.path.join(OUR_DIR, _ini_relpath)

"""
This test file assumes that the checks will be run in particular order.
This because a database needs to be installed with schemas.
After execution the changes will not be rolled back.
"""


def test_create_database():
    settings = SettingsObject(INI_ABSPATH)
    try:
        drop_database(settings)
    except Exception:
        pass
    create_database(settings)


def test_drop_database():
    settings = SettingsObject(INI_ABSPATH)
    drop_database(settings)


def test_init_threedidatabase():
    settings = SettingsObject(INI_ABSPATH)
    create_database(settings)
    ThreediDatabase(settings)
    drop_database(settings)


def test_init_threedidatabase_raise():
    settings = SettingsObject(INI_ABSPATH)
    settings.database = "unkown"
    with pytest.raises(Exception):
        ThreediDatabase(settings)


class TestCreateDB(TestCase):
    @classmethod
    def setUpClass(cls):
        cls.settings = SettingsObject(INI_ABSPATH)
        create_database(cls.settings)
        cls.db = ThreediDatabase(cls.settings)

    @classmethod
    def tearDownClass(cls):
        cls.db.conn.close()
        drop_database(cls.settings)

    def test_01_create_extension(self):
        self.db.create_extension(extension_name="postgis")

    def test_02_initialize_db_threedi(self):
        self.db.initialize_db_threedi()


class TestDB(TestCase):
    @classmethod
    def setUpClass(cls):
        cls.settings = SettingsObject(INI_ABSPATH)
        create_database(cls.settings)
        cls.db = ThreediDatabase(cls.settings)
        cls.db.create_extension(extension_name="postgis")
        cls.db.initialize_db_threedi()

    @classmethod
    def tearDownClass(cls):
        cls.db.conn.close()
        drop_database(cls.settings)

    def test_00_empty_database(self):
        self.db.empty_database()

    def test_01_create_schema(self):
        self.db.create_schema(schema_name="chk", drop_schema=True)

    def test_get_count(self):
        assert self.db.get_count("v2_manhole") >= 0

    def test_get_count_raise(self):
        with pytest.raises(Exception):
            self.db.get_count("unknown")

    def test_execute_sql_statement(self):
        self.db.execute_sql_statement("SELECT * FROM v2_manhole")

    def test_execute_sql_statement_raise(self):
        with pytest.raises(Exception):
            self.db.execute_sql_statement("SELECT * FROM unknown")

    def test_select_table_names(self):
        result = self.db.select_table_names("v2%")
        assert "v2_manhole" in result

    def test_populate_geometry_columns(self):
        self.db.populate_geometry_columns()

    # TODO: add checks for all types in sql.py

    def test_execute_sql_file(self):
        sql_relpath = os.path.join("sql", "sql_function_array_greatest_or_smallest.sql")
        sql_abspath = os.path.join(
            os.path.abspath(os.path.join(OUR_DIR, "..")), sql_relpath
        )
        self.db.execute_sql_file(sql_abspath)

    def test_create_view_from_dictionary(self):
        self.db.create_preset_view_from_dictionary(
            view_dictionary=sql_views,
            view_table="v2_1d_boundary_conditions_view",
            view_schema="chk",
        )

    def test_01_create_table(self):
        self.db.create_table(
            "test_create_table", ["test_id", "name"], ["Integer", "Varchar"]
        )

    def test_01_create_table_raise(self):
        with pytest.raises(Exception):
            self.db.create_table(None, ["test_id"], ["Integer"])

    def test_02_commit_values(self):
        self.db.commit_values(
            "test_create_table", "test_id, name", [(1, "test"), (2, "hoi")]
        )
        assert (
            self.db.execute_sql_statement(
                "SELECT name FROM test_create_table WHERE test_id = 1"
            )[0][0]
            == "test"
        )
