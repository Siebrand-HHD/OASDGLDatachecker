# -*- coding: utf-8 -*-
"""Tests for importer.py"""
import os

from OASDGLDatachecker.tool_quality_checks.importer import (
    get_field_value_as_dict_from_ogr_datasource,
    import_ogrdatasource_to_postgres,
)
from OASDGLDatachecker.tool_quality_checks.scripts import SettingsObject
from OASDGLDatachecker.tool_quality_checks.db import (
    ThreediDatabase,
    create_database,
    drop_database,
)
from unittest import TestCase

_ini_relpath = "data/instellingen_test.ini"
INI_ABSPATH = os.path.join(os.path.dirname(__file__), _ini_relpath)
_shp_relpath = "data/rioolput.shp"
SHP_ABSPATH = os.path.join(os.path.dirname(__file__), _shp_relpath)


def test_get_field_value_as_dict_from_ogr_datasource_shp():
    ds_records = get_field_value_as_dict_from_ogr_datasource(SHP_ABSPATH)
    assert ds_records[9]["DREMPELHOO"] == 9.52


def test_get_field_value_as_dict_from_ogr_datasource_gpkg():
    gpkg_relpath = "data/manhole_dtm_surface_level.gpkg"
    gpkg_abspath = os.path.join(os.path.dirname(__file__), gpkg_relpath)
    ds_records = get_field_value_as_dict_from_ogr_datasource(gpkg_abspath)
    assert ds_records[10]["maaiveld"] == -1.625


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

    @classmethod
    def tearDownClass(cls):
        cls.db.conn.close()
        # drop_database(cls.settings)

    def test_import_ogrdatasource_to_postgres(self):
        import_ogrdatasource_to_postgres(self.db, SHP_ABSPATH, "test")
        result = self.db.execute_sql_statement("SELECT * FROM test LIMIT 1")
        print(result)
