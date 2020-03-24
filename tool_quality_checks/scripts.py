# -*- coding: utf-8 -*-
""" TODO Docstring. """
import os
import argparse
import logging

from configparser import RawConfigParser
from OASDGLDatachecker.tool_quality_checks.check_sewerage import check_sewerage
from OASDGLDatachecker.tool_quality_checks.db import (
    ThreediDatabase,
    create_database,
    drop_database,
)
from OASDGLDatachecker.tool_quality_checks.importer import import_sewerage_data_into_db
from OASDGLDatachecker.tool_quality_checks.exporter import export_checks_from_db_to_gpkg


logger = logging.getLogger(__name__)
OUR_DIR = os.path.dirname(__file__)


def run_scripts(settings):
    """
    background program for running all functionalities
    """

    # block with only server connection
    if settings.dropdb:
        logger.info("Drop the Citybuilder database")
        drop_database(settings)

    if settings.createdb:
        logger.info("Create the Citybuilder database")
        create_database(settings)

    # block with database connection
    if settings.createdb or settings.import_type or settings.checks:
        db = ThreediDatabase(settings)

    if settings.createdb:
        logger.info("Initialize the Citybuilder database")
        db.initialize_db_threedi()

    if settings.import_type:
        logger.info("Import your sewerage data of %s" % settings.import_type)
        import_sewerage_data_into_db(db, settings)

    if settings.checks:
        logger.info("Check your sewerage system")
        check_sewerage(db, settings)

    if settings.export:
        logger.info("Export database to geopackage")
        export_checks_from_db_to_gpkg(settings)


def resolve_ini(custom_ini_file):
    """
    decide which ini file to use
    """
    # get default ini for testing purposes
    default_ini_relpath = os.path.join(OUR_DIR, "test", "data", "instellingen_test.ini")
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
            logger.error(
                "Setting '%s' is missing in your input. Please check the command line and ini-file."
                % name
            )
            raise


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
        "--createdb",
        default=False,
        help="Create CityBuilder database",
        dest="createdb",
        action="store_true",
    )
    parser.add_argument(
        "--dropdb",
        default=False,
        help="Drop CityBuilder database",
        dest="dropdb",
        action="store_true",
    )
    parser.add_argument(
        "--import",
        dest="import_type",
        default=False,
        choices=["gbi"],
        help="Import your sewerage data",
    )
    parser.add_argument(
        "-m",
        metavar="MANHOLE_FILE",
        dest="manhole_layer",
        help="Optional: Define path to manhole_layer (GBI) for automization options. This location could also be stored in the inifile.",
    )
    parser.add_argument(
        "-p",
        metavar="PIPE_FILE",
        dest="pipe_layer",
        help="Optional: Define path to pipe_layer (GBI) for automization options. This location could also be stored in the inifile.",
    )
    parser.add_argument(
        "--checks",
        default=False,
        help="Run quality checks for sewerage system",
        dest="checks",
        action="store_true",
    )
    parser.add_argument(
        "-d",
        "--dem",
        metavar="DEM_FILE",
        dest="dem",
        help="Optional: define path to raster with DEM values.",
    )
    parser.add_argument(
        "--export",
        default=False,
        help="Export quality checks to geopackage",
        dest="export",
        action="store_true",
    )
    parser.add_argument(
        "-g",
        "--gpkg",
        metavar="GPKG_OUTPUT_FILE",
        dest="gpkg_output_layer",
        help="Optional: define path to geopackage output file",
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
    for key, value in kwargs.items():
        # Skip none values so ini-file is not overwritten, like manhole_layer
        if not value is None:
            setattr(settings, key, value)
    run_scripts(settings)


if __name__ == "__main__":
    exit(main())
