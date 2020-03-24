# -*- coding: utf-8 -*-
""" 
Purpose to load postgres checks to geopackage
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
DRIVER_OGR_GPKG = ogr.GetDriverByName("GPKG")


def export_checks_from_db_to_gpkg(settings):
    """
    Export check files with sewerage background layers into a geopackage
    """

    # Create output geopackage datasource
    if os.path.isfile(settings.gpkg_output_layer):
        os.remove(settings.gpkg_output_layer)
    gpkg_out_source = None
    gpkg_out_source = DRIVER_OGR_GPKG.CreateDataSource(settings.gpkg_output_layer)

    # Create link with database
    in_source = set_ogr_connection_pg_database(settings)

    all_layers_in_source = []
    for i in in_source:
        layer_name = i.GetName()
        if not layer_name in all_layers_in_source:
            all_layers_in_source.append(layer_name)

    chk_layers_in_source = [
        l for l in all_layers_in_source if ("chk." in l or "model." in l)
    ]

    for in_layer_name in chk_layers_in_source:
        print(in_layer_name)
        copy2ogr(in_source, in_layer_name, gpkg_out_source, in_layer_name)
