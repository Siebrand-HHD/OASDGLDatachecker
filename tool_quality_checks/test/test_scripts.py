# -*- coding: utf-8 -*-
"""Tests for scripts.py"""
import os
import sys
import mock
import pytest

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))
import scripts
from scripts import SettingsObject
from scripts import resolve_ini


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
