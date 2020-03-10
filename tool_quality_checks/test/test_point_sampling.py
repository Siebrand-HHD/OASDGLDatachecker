# -*- coding: utf-8 -*-
"""Tests for point_sampling.py"""
import os

from OASDGLDatachecker.tool_quality_checks.importer import (
    importer,
    set_ogr_connection_pg_database,
)
from OASDGLDatachecker.tool_quality_checks.scripts import SettingsObject
from OASDGLDatachecker.tool_quality_checks.db import (
    ThreediDatabase,
    create_database,
    drop_database,
)
from OASDGLDatachecker.tool_quality_checks.point_sampling import (
    sample_points_and_create_pg_layer,
    get_inverse,
    create_empty_point_sample_layer,
)
from unittest import TestCase

_ini_relpath = "data/instellingen_test.ini"
INI_ABSPATH = os.path.join(os.path.dirname(__file__), _ini_relpath)
_shp_relpath = "data/rioolput.shp"
SHP_ABSPATH = os.path.join(os.path.dirname(__file__), _shp_relpath)


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
        # load GBI manholes only into tester
        manhole_layer_rel_path = "data\schiedam-test\schiedam-putten-test.shp"
        cls.settings.manhole_layer = os.path.join(
            os.path.dirname(__file__), manhole_layer_rel_path
        )
        cls.settings.import_type = "gbi"
        importer(cls.db, cls.settings)

    @classmethod
    def tearDownClass(cls):
        cls.db.conn.close()
        # drop_database(cls.settings)

    def test_get_inverse(self):
        inverse = get_inverse(1, 2, 3, 4)
        assert inverse == (-2.0, 1.0, 1.5, -0.5)

    def create_empty_point_sample_layer(self):
        conn = set_ogr_connection_pg_database(self.settings)
        create_empty_point_sample_layer(
            self.settings, conn, "v2_manhole_view", "test_maaiveld", "src", "test"
        )
        assert self.db.count("src.test_maaiveld") == 0
        conn.Destroy()

    def test_point_sampling(self):
        raster_rel_path = "data\schiedam-test\dem_schiedam_test.tif"
        raster_abs_path = os.path.join(os.path.dirname(__file__), raster_rel_path)
        sample_points_and_create_pg_layer(
            self.settings,
            raster_abs_path,
            "v2_manhole_view",
            "manhole_maaiveld",
            "src",
            self.settings.dem_field,
        )
        assert (
            self.db.execute_sql_statement(
                "SELECT maaiveld FROM src.manhole_maaiveld WHERE id = 1"
            )[0][0]
            == 0.31
        )
