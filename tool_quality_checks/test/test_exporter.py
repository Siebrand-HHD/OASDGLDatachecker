# -*- coding: utf-8 -*-
"""Tests for importer.py"""
import os

from OASDGLDatachecker.tool_quality_checks.exporter import export_checks_from_db_to_gpkg
from OASDGLDatachecker.tool_quality_checks.scripts import SettingsObject
from OASDGLDatachecker.tool_quality_checks.db import (
    ThreediDatabase,
    create_database,
    drop_database,
)
from OASDGLDatachecker.tool_quality_checks.importer import import_sewerage_data_into_db
from OASDGLDatachecker.tool_quality_checks.check_sewerage import check_sewerage
from OASDGLDatachecker.tool_quality_checks.copy_ogr_layer import set_ogr_connection
from unittest import TestCase

OUR_DIR = os.path.dirname(__file__)
_ini_relpath = "data/instellingen_test.ini"
INI_ABSPATH = os.path.join(OUR_DIR, _ini_relpath)
_shp_relpath = "data/rioolput.shp"
SHP_ABSPATH = os.path.join(OUR_DIR, _shp_relpath)


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
        manhole_layer_rel_path = "data/schiedam-test/schiedam-putten-test.shp"
        cls.settings.manhole_layer = os.path.join(OUR_DIR, manhole_layer_rel_path)
        pipe_layer_rel_path = "data/schiedam-test/schiedam-leidingen-test.shp"
        cls.settings.pipe_layer = os.path.join(OUR_DIR, pipe_layer_rel_path)
        cls.settings.import_type = "gbi"
        import_sewerage_data_into_db(cls.db, cls.settings)
        raster_rel_path = "data/schiedam-test/dem_schiedam_test.tif"
        cls.settings.dem = os.path.join(OUR_DIR, raster_rel_path)
        check_sewerage(cls.db, cls.settings)

    @classmethod
    def tearDownClass(cls):
        cls.db.conn.close()
        drop_database(cls.settings)

    def test_export_checks_from_db_to_gpkg(self):
        self.settings.gpkg_output_layer = os.path.join(
            OUR_DIR, "data/schiedam-test/export_exporter.gpkg"
        )
        export_checks_from_db_to_gpkg(self.settings)
        in_source = set_ogr_connection(self.settings.gpkg_output_layer)
        assert in_source.GetLayerCount() == 41
