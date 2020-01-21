# -*- coding: utf-8 -*-
""" TODO Docstring. """
import os
import argparse
import logging

from configparser import RawConfigParser
from OASDGLDatachecker.tool_quality_checks.quality_checks import quality_checks

logger = logging.getLogger(__name__)


def resolve_ini(custom_ini_file):
    """
    decide which ini file to use
    """
    # get default ini for testing purposes
    default_ini_relpath = os.path.join("test", "data", "instellingen_test.ini")
    default_ini_relpath = os.path.join(os.path.dirname(__file__), default_ini_relpath)
    if custom_ini_file is None:
        logger.info(
            "[*] Using default ini file {}".format(
                os.path.basename(default_ini_relpath)
            )
        )
        return default_ini_relpath
    elif all((os.path.exists(custom_ini_file), os.path.isfile(custom_ini_file))):
        logger.info(
            "[*] Using custom ini file {}".format(os.path.basename(custom_ini_file))
        )
        return custom_ini_file
    else:
        raise ("Error: Could not find the custom ini file {}".format(custom_ini_file))


class SettingsObject(object):
    """Contains the settings from the ini file"""

    def __init__(self, inifile):
        config = RawConfigParser()
        config.read(inifile)

        # inifile
        self.ini = inifile

        for section in config.sections():
            for key, value in config.items(section):
                setattr(self, key, value)

    def __getattribute__(self, name):
        try:
            return super().__getattribute__(name)
        except AttributeError:
            raise AttributeError("Setting '%s' is missing in the ini-file" % name)


def get_parser():
    """ Return argument parser. """
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "-v",
        "--verbose",
        action="store_true",
        dest="verbose",
        default=False,
        help="Verbose output",
    )
    parser.add_argument(
        "--install",
        default=False,
        help="Install CityBuilder into database",
        dest="install",
        action="store_true",
    )
    parser.add_argument(
        "-i",
        "--inifile",
        metavar="INIFILE",
        dest="inifile",
        help="Location with settings ini for quality checks",
    )

    return parser


def main():
    """ Call command with args from parser. """
    kwargs = vars(get_parser().parse_args())
    if kwargs["verbose"]:
        log_level = logging.DEBUG
    else:
        log_level = logging.INFO
    logging.basicConfig(level=log_level, format="%(levelname)s: %(message)s")
    ini_relpath = resolve_ini(kwargs["inifile"])
    settings = SettingsObject(ini_relpath)
    settings.install = kwargs["install"]
    quality_checks(settings)


if __name__ == "__main__":
    exit(main())
