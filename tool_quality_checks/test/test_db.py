# -*- coding: utf-8 -*-
"""Tests for db.py"""
import os
import sys
import pytest

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "../..")))
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
