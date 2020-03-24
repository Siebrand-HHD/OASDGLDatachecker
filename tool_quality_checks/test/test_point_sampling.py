# -*- coding: utf-8 -*-
"""Tests for point_sampling.py"""
import os

from OASDGLDatachecker.tool_quality_checks.importer import (
    import_sewerage_data_into_db,
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
    create_point_sample_layer,
)
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
        # load GBI manholes only into tester
        manhole_layer_rel_path = "data\schiedam-test\schiedam-putten-test.shp"
        cls.settings.manhole_layer = os.path.join(OUR_DIR, manhole_layer_rel_path)
        cls.settings.import_type = "gbi"
        import_sewerage_data_into_db(cls.db, cls.settings)

    @classmethod
    def tearDownClass(cls):
        cls.db.conn.close()
        # drop_database(cls.settings)

    def test_get_inverse(self):
        inverse = get_inverse(1, 2, 3, 4)
        assert inverse == (-2.0, 1.0, 1.5, -0.5)

    def test_create_point_sample_layer(self):
        conn = set_ogr_connection_pg_database(self.settings)
        create_point_sample_layer(
            self.settings,
            conn,
            input_point_layer="v2_manhole_view",
            output_point_layer="test_maaiveld",
            output_schema="src",
            output_raster_column="test",
        )
        assert self.db.get_count("test_maaiveld", "src") == 10
        conn.Destroy()

    def test_point_sampling(self):
        raster_rel_path = "data\schiedam-test\dem_schiedam_test.tif"
        raster_abs_path = os.path.join(OUR_DIR, raster_rel_path)
        sample_points_and_create_pg_layer(
            self.settings,
            raster_abs_path,
            "v2_manhole_view",
            "manhole_maaiveld",
            "src",
            "maaiveld",
        )
        assert (
            self.db.execute_sql_statement(
                "SELECT maaiveld FROM src.manhole_maaiveld WHERE id = 1"
            )[0][0]
            == 0.31
        )
