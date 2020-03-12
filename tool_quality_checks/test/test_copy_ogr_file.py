# -*- coding: utf-8 -*-
"""Tests for importer.py"""
import os
import pytest
from osgeo import osr
from os.path import basename

from OASDGLDatachecker.tool_quality_checks.copy_ogr_file import (
    set_ogr_connection_pg_database,
    set_ogr_connection,
    copy2ogr,
    get_projection,
)
from OASDGLDatachecker.tool_quality_checks.scripts import SettingsObject
from OASDGLDatachecker.tool_quality_checks.db import (
    ThreediDatabase,
    create_database,
    drop_database,
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
        cls.db.create_schema("src")

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

    def test_01_copy2ogr_shp2pg(self):
        file_with_extention = basename(SHP_ABSPATH)
        filename, file_extension = os.path.splitext(file_with_extention)
        in_source = set_ogr_connection(SHP_ABSPATH)
        out_source = set_ogr_connection_pg_database(self.settings)
        copy2ogr(in_source, filename, out_source, "test")
        assert self.db.get_count("test") == 78

    def test_02_copy2ogr_pg2pg(self):
        in_source = set_ogr_connection_pg_database(self.settings)
        out_source = in_source
        copy2ogr(in_source, "test", out_source, "test_2", schema="src")
        assert self.db.get_count("test_2", schema="src") == 78

    # def test_02_copy2ogr_pg2gpkg(self):
    #     in_source = set_ogr_connection_pg_database(self.settings)

    #     # TODO TEST PART NEEDS FUNCTION LATER

    #     out_source =

    #     copy2ogr(in_source, "test", out_source, "test", schema="src")
    #     assert self.db.get_count("test_2", schema="src") == 78

    def test_copy2pg_database_no_ds_raise(self):
        in_source = set_ogr_connection_pg_database(self.settings)
        out_source = in_source
        with pytest.raises(AttributeError):
            copy2ogr(in_source, "not_existing", out_source, "test_2", schema="src")

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
