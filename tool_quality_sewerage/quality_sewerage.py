# -*- coding: utf-8 -*-
""" TODO Docstring. """

import argparse
import logging
import datetime
from collections import OrderedDict
from configparser import RawConfigParser


def quality_sewerage(inifile):
    print('test')

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
        "inifile", metavar="INIFILE", help="Location with settings ini for quality checks"
    )

    return parser

def main():
    """ Call command with args from parser. """
    kwargs = vars(get_parser().parse_args())
    logging.basicConfig(level=logging.INFO, format="%(levelname)s: %(message)s")
    settings = settingsObject(kwargs["inifile"])
    quality_sewerage(settings)


if __name__ == "__main__":
    exit(main())