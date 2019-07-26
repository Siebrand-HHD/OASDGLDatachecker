# -*- coding: utf-8 -*-
"""Tests for db.py"""
import os
import sys
import pytest

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "../..")))
from quality_checks import settingsObject
from db import ThreediDatabase


def test_init_threedidatabase():
    ini_relpath = "data//instellingen_test.ini"
    ini_abspath = os.path.join(os.path.dirname(__file__), ini_relpath)
    settings = settingsObject(ini_abspath)
    ThreediDatabase(settings)


def test_init_threedidatabase_raise(mocker):
    ini_relpath = "data//instellingen_test.ini"
    ini_abspath = os.path.join(os.path.dirname(__file__), ini_relpath)
    settings = settingsObject(ini_abspath)
    settings.database = "unkown"
    with pytest.raises(Exception):
        ThreediDatabase(settings)


def test_get_count():
    ini_relpath = "data//instellingen_test.ini"
    ini_abspath = os.path.join(os.path.dirname(__file__), ini_relpath)
    settings = settingsObject(ini_abspath)
    db = ThreediDatabase(settings)
    assert db.get_count("v2_manhole") >= 0


def test_get_count_raise():
    ini_relpath = "data//instellingen_test.ini"
    ini_abspath = os.path.join(os.path.dirname(__file__), ini_relpath)
    settings = settingsObject(ini_abspath)
    db = ThreediDatabase(settings)
    with pytest.raises(Exception):
        db.get_count("unknown")
