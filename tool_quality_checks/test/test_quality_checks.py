# -*- coding: utf-8 -*-
"""Tests for quality_checks.py"""
import os
import sys
import mock

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "../..")))
import quality_checks
from quality_checks import settingsObject


@mock.patch("sys.argv", ["program", "test.ini"])
def test_get_parser():
    parser = quality_checks.get_parser()
    # As a test, we just check one option. That's enough.
    options = parser.parse_args()
    assert options.inifile == "test.ini"


def test_settingsobject():
    ini_relpath = "data//instellingen_test.ini"
    ini_abspath = os.path.join(os.path.dirname(__file__), ini_relpath)
    settings = settingsObject(ini_abspath)
    assert settings.__dict__["hoogte_verschil"] == "0.2"
