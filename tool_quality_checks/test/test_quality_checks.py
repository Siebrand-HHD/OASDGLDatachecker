# -*- coding: utf-8 -*-
"""Tests for quality_checks.py"""
import os
from unittest import TestCase
import pytest

from OASDGLDatachecker.tool_quality_checks.scripts import SettingsObject
from OASDGLDatachecker.tool_quality_checks.db import (
    ThreediDatabase,
    create_database,
    drop_database,
)
from OASDGLDatachecker.tool_quality_checks.quality_checks import (
    initialize_db_checks,
    perform_checks_with_sql,
)

_ini_relpath = "data/instellingen_test.ini"
INI_ABSPATH = os.path.join(os.path.dirname(__file__), _ini_relpath)

"""
This test file assumes that the checks will be run in particular order.
This because a database needs to be installed with schemas.
After execution the changes will not be rolled back.
"""


class TestDB(TestCase):
    @classmethod
    def setUpClass(cls):
        cls.settings = SettingsObject(INI_ABSPATH)
        try:
            drop_database(cls.settings)
        except Exception:
            pass
        create_database(cls.settings)
        cls.db = ThreediDatabase(cls.settings)
        cls.db.create_extension(extension_name="postgis")
        cls.db.initialize_db_threedi()

    @classmethod
    def tearDownClass(cls):
        cls.db.conn.close()
        drop_database(cls.settings)

    def test_initialize_db_checks(self):
        initialize_db_checks(self.db)

    def test_perform_checks_with_sql(self):
        perform_checks_with_sql(self.db, self.settings, "v2_manhole", "completeness")

    def test_perform_checks_with_sql_raise(self):
        ini_relpath_key_missing = "data/instellingen_test_missing_key.ini"
        ini_abspath_key_missing = os.path.join(
            os.path.dirname(__file__), ini_relpath_key_missing
        )
        test_settings = SettingsObject(ini_abspath_key_missing)
        with pytest.raises(Exception):
            self.db.perform_checks_with_sql(
                self.db, test_settings, "v2_manhole", "completeness"
            )
