# -*- coding: utf-8 -*-
"""Tests for scripts.py"""
import os
import sys
import mock
import pytest

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))
import scripts
from OASDGLDatachecker.tool_quality_checks.scripts import (
    SettingsObject,
    resolve_ini,
    main,
)


@mock.patch("sys.argv", ["program", "-i", "test.ini"])
def test_get_parser():
    parser = scripts.get_parser()
    # As a test, we just check one option. That's enough.
    options = parser.parse_args()
    assert options.inifile == "test.ini"


def test_settingsobject():
    ini_path = "data//instellingen_test.ini"
    ini_path = os.path.join(os.path.dirname(__file__), ini_path)
    settings = SettingsObject(ini_path)
    assert settings.__dict__["hoogte_verschil"] == "0.2"


def test_settingsobject_raise():
    ini_path = "data//instellingen_test_missing_db.ini"
    ini_path = os.path.join(os.path.dirname(__file__), ini_path)
    settings = SettingsObject(ini_path)
    with pytest.raises(Exception):
        settings.database


def test_resolve_ini_custom():
    ini_path = "data\\dummy.ini"
    ini_path = os.path.join(os.path.dirname(__file__), ini_path)
    ini_path = resolve_ini(ini_path)
    assert "\\test\\data\\dummy.ini" in ini_path


def test_resolve_ini_default():
    ini_path = resolve_ini(None)
    assert "\\test\\data\\instellingen_test.ini" in ini_path


def test_resolve_ini_error():
    with pytest.raises(Exception):
        resolve_ini("instellingen_test_error.ini")


"LARGE TESTS"
# create absolute path to ini
_ini_relpath = "data/instellingen_mini_schiedam.ini"
ini_abspath_full_check = os.path.join(os.path.dirname(__file__), _ini_relpath)
_manhole_layer_rel_path = "data\schiedam-test\schiedam-putten-test.shp"
manhole_layer_abs_path = os.path.join(
    os.path.dirname(__file__), _manhole_layer_rel_path
)
_pipe_layer_rel_path = "data\schiedam-test\schiedam-leidingen-test.shp"
pipe_layer_abs_path = os.path.join(os.path.dirname(__file__), _pipe_layer_rel_path)
_raster_rel_path = "data\schiedam-test\dem_schiedam_test.tif"
raster_abs_path = os.path.join(os.path.dirname(__file__), _raster_rel_path)


@mock.patch(
    "sys.argv",
    [
        "program",
        "-i",
        ini_abspath_full_check,
        "--createdb",
        "--dropdb",
        "--import",
        "gbi",
        "-m",
        manhole_layer_abs_path,
        "-p",
        pipe_layer_abs_path,
        "-d",
        raster_abs_path,
        "--checks",
    ],
)
def test_main_run_scripts_full():
    main()
    # TODO Add asserts to check all elements
