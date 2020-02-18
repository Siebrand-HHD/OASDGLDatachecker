# -*- coding: utf-8 -*-
"""Tests for importer.py"""
import os
import pytest
from osgeo import osr
from os.path import basename

from OASDGLDatachecker.tool_quality_checks.importer import (
    set_ogr_connection_pg_database,
    set_ogr_connection,
    copy2pg_database,
    get_projection,
    import_file_based_on_filetype,
    importer,
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
_shp_relpath = "data/schiedam-test/schiedam-leidingen-test.shp"
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

    @classmethod
    def tearDownClass(cls):
        cls.db.conn.close()
        # drop_database(cls.settings)

    def test_ogr_connection_pg_database(self):
        set_ogr_connection_pg_database(self.settings)

    def test_ogr_connection(self):
        set_ogr_connection(SHP_ABSPATH)

    def test_ogr_connection_raise(self):
        filepath = "xx.shp"
        with pytest.raises(Exception):
            set_ogr_connection(filepath)

    def test_copy2pg_database(self):
        file_with_extention = basename(SHP_ABSPATH)
        filename, file_extension = os.path.splitext(file_with_extention)
        copy2pg_database(self.settings, SHP_ABSPATH, filename, "test")
        assert self.db.get_count("test") == 78

    def test_get_projection_not_good(self):
        proj = """PROJCS["Amersfoort_RD_New",GEOGCS["GCS_Amersfoort",DATUM["D_Amersfoort",SPHEROID["Bessel_1841",6377397.155,299.1528128]],PRIMEM["Greenwich",0],UNIT["Degree",0.017453292519943295]],PROJECTION["Double_Stereographic"],PARAMETER["latitude_of_origin",52.15616055555555],PARAMETER["central_meridian",5.38763888888889],PARAMETER["scale_factor",0.9999079],PARAMETER["false_easting",155000],PARAMETER["false_northing",463000],UNIT["Meter",1]]"""
        sr = osr.SpatialReference()
        sr.ImportFromWkt(proj)
        assert get_projection(sr) == None

    def test_get_projection_good(self):
        proj = """PROJCS["Amersfoort / RD New",GEOGCS["Amersfoort",DATUM["Amersfoort",SPHEROID["Bessel 1841",6377397.155,299.1528128,AUTHORITY["EPSG","7004"]],TOWGS84[565.417,50.3319,465.552,-0.398957,0.343988,-1.8774,4.0725],AUTHORITY["EPSG","6289"]],PRIMEM["Greenwich",0,AUTHORITY["EPSG","8901"]],UNIT["degree",0.0174532925199433,AUTHORITY["EPSG","9122"]],AUTHORITY["EPSG","4289"]],PROJECTION["Oblique_Stereographic"],PARAMETER["latitude_of_origin",52.15616055555555],PARAMETER["central_meridian",5.38763888888889],PARAMETER["scale_factor",0.9999079],PARAMETER["false_easting",155000],PARAMETER["false_northing",463000],UNIT["metre",1,AUTHORITY["EPSG","9001"]],AXIS["X",EAST],AXIS["Y",NORTH],AUTHORITY["EPSG","28992"]]"""
        sr = osr.SpatialReference()
        sr.ImportFromWkt(proj)
        assert get_projection(sr) == "EPSG:28992"

    def test_import_filetype(self):
        self.db.create_schema("src")
        import_file_based_on_filetype(
            self.db, self.settings, SHP_ABSPATH, out_name="leidingen_test"
        )
        assert self.db.get_count("leidingen_test", "src") == 11

    def test_import_filetype_file_does_not_exists(self):
        with pytest.raises(FileNotFoundError):
            import_file_based_on_filetype(
                self.db, self.settings, file_path="kjfdla.zzp", out_name="test"
            )

    def test_import_filetype_file_not_supported(self):
        with pytest.raises(AttributeError):
            import_file_based_on_filetype(
                self.db, self.settings, file_path=INI_ABSPATH, out_name="test"
            )

    def test_importer(self):
        self.settings.manhole_layer = SHP_ABSPATH
        pipe_layer_rel_path = "data\schiedam-test\schiedam-leidingen-test.shp"
        self.settings.pipe_layer = os.path.join(
            os.path.dirname(__file__), pipe_layer_rel_path
        )
        self.settings.import_type = "gbi"
        importer(self.db, self.settings)
        assert self.db.get_count("leidingen", "gbi") == 10
        assert self.db.get_count("v2_pipe", "public") == 10
