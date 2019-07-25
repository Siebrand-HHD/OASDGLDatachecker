# -*- coding: utf-8 -*-
"""Tests for quality_checks.py"""
import os
import sys
import mock

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))
import quality_checks
from quality_checks import settingsObject
from quality_checks import resolve_ini


@mock.patch("sys.argv", ["program", "-i", "test.ini"])
def test_get_parser():
    parser = quality_checks.get_parser()
    # As a test, we just check one option. That's enough.
    options = parser.parse_args()
    assert options.inifile == "test.ini"


def test_settingsobject():
    ini_path = "data//instellingen_test.ini"
    ini_path = os.path.join(os.path.dirname(__file__), ini_path)
    settings = settingsObject(ini_path)
    assert settings.__dict__["hoogte_verschil"] == "0.2"


def test_resolve_ini_custom():
    ini_path = "data\\dummy.ini"
    ini_path = os.path.join(os.path.dirname(__file__), ini_path)
    ini_path = resolve_ini(ini_path)
    print(ini_path)
    assert "\\test\\data\\dummy.ini" in ini_path


def test_resolve_ini_default():
    ini_path = resolve_ini(None)
    print(ini_path)
    assert "\\test\\data\\instellingen_test.ini" in ini_path
