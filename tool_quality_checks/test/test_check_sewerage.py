# -*- coding: utf-8 -*-
"""Tests for check_sewerage.py"""
import os
from unittest import TestCase
import pytest

from OASDGLDatachecker.tool_quality_checks.scripts import SettingsObject
from OASDGLDatachecker.tool_quality_checks.db import (
    ThreediDatabase,
    create_database,
    drop_database,
)
from OASDGLDatachecker.tool_quality_checks.importer import import_sewerage_data_into_db
from OASDGLDatachecker.tool_quality_checks.check_sewerage import (
    initialize_db_checks,
    perform_checks_with_sql,
    check_sewerage,
)

OUR_DIR = os.path.dirname(__file__)
_ini_relpath = "data/instellingen_test.ini"
INI_ABSPATH = os.path.join(OUR_DIR, _ini_relpath)

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
        # load GBI data set into tester
        manhole_layer_rel_path = "data\schiedam-test\schiedam-putten-test.shp"
        cls.settings.manhole_layer = os.path.join(
            os.path.dirname(__file__), manhole_layer_rel_path
        )
        pipe_layer_rel_path = "data\schiedam-test\schiedam-leidingen-test.shp"
        cls.settings.pipe_layer = os.path.join(
            os.path.dirname(__file__), pipe_layer_rel_path
        )
        cls.settings.import_type = "gbi"
        import_sewerage_data_into_db(cls.db, cls.settings)

    @classmethod
    def tearDownClass(cls):
        cls.db.conn.close()
        # drop_database(cls.settings)

    def test_initialize_db_checks(self):
        initialize_db_checks(self.db)

    def test_perform_checks_with_sql(self):
        perform_checks_with_sql(self.db, self.settings, "v2_manhole", "completeness")

    def test_perform_checks_with_sql_raise(self):
        ini_relpath_key_missing = "data/instellingen_test_missing_key.ini"
        ini_abspath_key_missing = os.path.join(OUR_DIR, ini_relpath_key_missing)
        test_settings = SettingsObject(ini_abspath_key_missing)
        with pytest.raises(Exception):
            self.db.perform_checks_with_sql(
                self.db, test_settings, "v2_manhole", "completeness"
            )

    def test_01_check_sewerage_no_dem(self):
        check_sewerage(self.db, self.settings)
        assert self.db.get_count("put_shape", "chk") == 1
        assert self.db.get_count("put_maaiveld_check", "chk") == 0

    def test_02_check_sewerage(self):
        raster_rel_path = "data\schiedam-test\dem_schiedam_test.tif"
        self.settings.dem = os.path.join(os.path.dirname(__file__), raster_rel_path)
        check_sewerage(self.db, self.settings)
        assert self.db.get_count("put_shape", "chk") == 1
        assert "-8847.45" in str(
            self.db.execute_sql_statement(
                "SELECT hoogte_verschil FROM chk.put_maaiveld_check"
            )[0][0]
        )
