# -*- coding: utf-8 -*-
""" TODO Docstring. """
import os
import argparse
import logging

from configparser import RawConfigParser
from db import ThreediDatabase

logger = logging.getLogger(__name__)


def quality_checks(settings):
    """Overall function for checking our model data"""

    # get database connection
    db = ThreediDatabase(settings)

    # get v2_table_names
    v2_table_names = db.select_table_names("v2%")
    for table_name in v2_table_names:
        print(table_name, db.get_count(table_name))


def resolve_ini(custom_ini_file):
    """
        decide which ini file to use
        """
    # get default ini for testing purposes
    default_ini_relpath = "test\\data\\instellingen_test.ini"
    default_ini_relpath = os.path.join(os.path.dirname(__file__), default_ini_relpath)
    if custom_ini_file is None:
        logger.info(
            "[*] Using default ini file {}".format(
                os.path.basename(default_ini_relpath)
            )
        )
        return default_ini_relpath
    if all((os.path.exists(custom_ini_file), os.path.isfile(custom_ini_file))):
        logger.info(
            "[*] Using custom ini file {}".format(os.path.basename(custom_ini_file))
        )
        return custom_ini_file
    else:
        raise ("Error: Could not find the ini file {}".format(custom_ini_file))


class settingsObject(object):
    """Contains the settings from the ini file"""

    def __init__(self, inifile):
        config = RawConfigParser()
        config.read(inifile)

        # inifile
        self.ini = inifile

        for section in config.sections():
            for key, value in config.items(section):
                setattr(self, key, value)


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
    print(ini_relpath)
    settings = settingsObject(ini_relpath)
    quality_checks(settings)


if __name__ == "__main__":
    exit(main())
