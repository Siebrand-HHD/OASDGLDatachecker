# -*- coding: utf-8 -*-
""" TODO Docstring. """

import argparse
import logging
from configparser import RawConfigParser


def quality_checks(inifile):
    """Overall function for checking our model data"""
    print("test")


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
        "inifile",
        metavar="INIFILE",
        help="Location with settings ini for quality checks",
    )

    return parser


def main():
    """ Call command with args from parser. """
    kwargs = vars(get_parser().parse_args())
    if kwargs.verbose:
        log_level = logging.DEBUG
    else:
        log_level = logging.INFO
    logging.basicConfig(level=log_level, format="%(levelname)s: %(message)s")
    settings = settingsObject(kwargs["inifile"])
    quality_checks(settings)


if __name__ == "__main__":
    exit(main())
