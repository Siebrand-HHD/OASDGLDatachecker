# -*- coding: utf-8 -*-
""" 
Purpose to load OGR data like shapefiles into postgres
"""
import os
import logging
from osgeo import ogr
from os.path import basename
from OASDGLDatachecker.tool_quality_checks.copy_ogr_layer import (
    copy2ogr,
    set_ogr_connection,
    set_ogr_connection_pg_database,
)

logger = logging.getLogger(__name__)
ogr.UseExceptions()
OUR_DIR = os.path.dirname(__file__)


def import_sewerage_data_into_db(db, settings):
    """
    Load input files into the database for checks
    """
    # check if relevant parameters are there:
    if not hasattr(settings, "manhole_layer"):
        logger.error("Input file path for manhole layer is missing")
        raise AttributeError()

    # initialize source schema
    db.create_schema("src")

    import_file_based_on_filetype(
        settings, settings.manhole_layer, "putten_" + settings.import_type
    )

    # check if pipe_layer is available
    if hasattr(settings, "pipe_layer"):
        import_file_based_on_filetype(
            settings, settings.pipe_layer, "leidingen_" + settings.import_type
        )
        has_gbi_pipe_layer = True
    else:
        logger.warning("Pipe layer is not available.")
        has_gbi_pipe_layer = False

    if settings.import_type == "gbi":
        sql_relpath = os.path.join("sql", "sql_gbi_manholes_to_3di.sql")
        sql_abspath = os.path.join(OUR_DIR, sql_relpath)
        db.execute_sql_file(sql_abspath)
        if has_gbi_pipe_layer:
            sql_relpath = os.path.join("sql", "sql_gbi_pipes_to_3di.sql")
            sql_abspath = os.path.join(OUR_DIR, sql_relpath)
            db.execute_sql_file(sql_abspath)


def import_file_based_on_filetype(settings, file_path, out_name):
    """
        Check file type and send request to copy to database function
    """

    if not os.path.isfile(file_path):
        logger.error("File %s does not exists " % file_path)
        raise FileNotFoundError()

    # prepare file import
    file_with_extention = basename(file_path)
    filename, file_extension = os.path.splitext(file_with_extention)
    out_source = set_ogr_connection_pg_database(settings)

    if file_extension == ".shp":
        in_source = set_ogr_connection(file_path)
        copy2ogr(in_source, filename, out_source, out_name, schema="src")
        in_source.Destroy()
    else:
        logger.error(
            "File extension of %s is not supported by this tool, please use .shp"
            % file_path
        )
        raise AttributeError()