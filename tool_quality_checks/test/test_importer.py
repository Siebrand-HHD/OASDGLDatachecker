# -*- coding: utf-8 -*-
"""Tests for importer.py"""
import os
import pytest

from OASDGLDatachecker.tool_quality_checks.importer import (
    import_file_based_on_filetype,
    import_sewerage_data_into_db,
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
        drop_database(cls.settings)

    def test_import_filetype(self):
        import_file_based_on_filetype(
            self.settings, SHP_ABSPATH, out_name="putten_test"
        )
        assert self.db.get_count("putten_test", "src") == 79

    def test_import_filetype_file_does_not_exists(self):
        with pytest.raises(FileNotFoundError):
            import_file_based_on_filetype(
                self.settings, file_path="kjfdla.zzp", out_name="test"
            )

    def test_import_filetype_file_not_supported(self):
        with pytest.raises(AttributeError):
            import_file_based_on_filetype(
                self.settings, file_path=INI_ABSPATH, out_name="test"
            )

    def test_sql_empty_database(self):
        # CURRENTLY USED FOR TESTS ONLY
        sql_relpath = os.path.join("sql", "sql_empty_3di_database.sql")
        sql_abspath = os.path.join(
            os.path.abspath(os.path.join(OUR_DIR, "..")), sql_relpath
        )
        self.db.execute_sql_file(sql_abspath)

    def test_01_importer_relevant_settings_are_missing(self):
        # run before others with 01
        with pytest.raises(AttributeError):
            import_sewerage_data_into_db(self.db, self.settings)

    def test_02_importer_manhole_only(self):
        # extra check is to check loading of date-types (2011-10-28) into the database
        manhole_layer_rel_path = "data\schiedam-test\schiedam-putten-test.shp"
        self.settings.manhole_layer = os.path.join(OUR_DIR, manhole_layer_rel_path)
        self.settings.import_type = "gbi"
        import_sewerage_data_into_db(self.db, self.settings)
        assert self.db.get_count("putten_gbi", "src") == 10
        assert self.db.get_count("v2_manhole", "public") == 10
        sql_relpath = os.path.join("sql", "sql_empty_3di_database.sql")
        sql_abspath = os.path.join(
            os.path.abspath(os.path.join(OUR_DIR, "..")), sql_relpath
        )
        self.db.execute_sql_file(sql_abspath)

    def test_03_importer_manholes_and_pipes(self):
        # extra check is to check loading of date-types (2011-10-28) into the database
        manhole_layer_rel_path = "data\schiedam-test\schiedam-putten-test.shp"
        self.settings.manhole_layer = os.path.join(OUR_DIR, manhole_layer_rel_path)
        pipe_layer_rel_path = "data\schiedam-test\schiedam-leidingen-test.shp"
        self.settings.pipe_layer = os.path.join(OUR_DIR, pipe_layer_rel_path)
        self.settings.import_type = "gbi"
        import_sewerage_data_into_db(self.db, self.settings)
        assert self.db.get_count("leidingen_gbi", "src") == 11
        assert self.db.get_count("v2_pipe", "public") == 11
        assert self.db.get_count("v2_cross_section_definition", "public") == 5
