# -*- coding: utf-8 -*-
"""Tests for db.py"""
import os
import sys
import pytest

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))
from quality_checks import settingsObject
from db import ThreediDatabase

from unittest import TestCase


class TestDB(TestCase):
    def setUp(self):
        ini_relpath = "data//instellingen_test.ini"
        ini_abspath = os.path.join(os.path.dirname(__file__), ini_relpath)
        self.settings = settingsObject(ini_abspath)
        self.db = ThreediDatabase(self.settings)

    def test_init_threedidatabase(self):
        ThreediDatabase(self.settings)

    def test_init_threedidatabase_raise(self):
        self.settings.database = "unkown"
        with pytest.raises(Exception):
            ThreediDatabase(self.settings)

    def test_initialize_db(self):
        self.db.initialize_db()

    def test_get_count(self):
        assert self.db.get_count("v2_manhole") >= 0

    def test_get_count_raise(self):
        with pytest.raises(Exception):
            self.db.get_count("unknown")

    def test_free_form(self):
        self.db.free_form("SELECT * FROM v2_manhole")

    def test_free_form_raise(self):
        with pytest.raises(Exception):
            self.db.free_form("SELECT * FROM unknown")

    def test_select_table_names(self):
        result = self.db.select_table_names("v2%")
        assert "v2_manhole" in result

    def test_create_schema(self):
        self.db.create_schema(schema_name="chk", drop_schema=True)

    def test_create_table(self):
        self.db.create_table("test_create_table", ["test_id"], ["Integer"])

    def test_create_table_raise(self):
        with pytest.raises(Exception):
            self.db.create_table(None, ["test_id"], ["Integer"])

    def test_populate_geometry_columns(self):
        self.db.populate_geometry_columns()

    def test_perform_checks_with_sql(self):
        self.db.perform_checks_with_sql(self.settings, "v2_manhole", "completeness")

    # TODO: add checks for all types in sql.py

    def test_execute_sql_file(self):
        sql_relpath = "sql_functions\\function_array_greatest_or_smallest.sql"
        sql_abspath = os.path.join(
            os.path.abspath(os.path.join(os.path.dirname(__file__), "..")), sql_relpath
        )
        self.db.execute_sql_file(sql_abspath)

    def test_execute_sql_dir(self):
        sql_reldir = "sql_functions"
        sql_absdir = os.path.join(
            os.path.abspath(os.path.join(os.path.dirname(__file__), "..")), sql_reldir
        )
        self.db.execute_sql_dir(sql_absdir)
