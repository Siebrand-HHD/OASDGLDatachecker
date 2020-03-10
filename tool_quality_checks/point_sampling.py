#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Samples the DEM based on a table in a PostGIS database
input: tif-file with elevation data and PostGIS table with point geometries
output: new PostGIS table with dem values
"""
import logging
from osgeo import gdal, ogr
import numpy as np

from OASDGLDatachecker.tool_quality_checks.importer import (
    set_ogr_connection_pg_database,
    copy2pg_database,
)

logger = logging.getLogger(__name__)
gdal.UseExceptions()


# def sample_points(dem, database, inputpoints, outputpoints, s):
def sample_points_and_create_pg_layer(
    settings,
    raster_path,
    input_point_layer,
    output_point_layer,
    output_schema,
    output_raster_field,
):
    """
    Main part to sample points

    Settings contains conneciton with the database
    Raster_path describes the path which you would like to sample
    Input_point_layer: name and schema of layer with points
    Output_point_layer: name of layer with points
    """
    # initialise progress bar
    # ogr.TermProgress_nocb(0)

    # Load Raster
    raster = gdal.Open(raster_path)
    geo_transform = raster.GetGeoTransform()
    raster_band = raster.GetRasterBand(1)

    # Connect met de database
    conn = set_ogr_connection_pg_database(settings)

    # Create target layer
    target_layer = create_empty_point_sample_layer(
        settings,
        conn,
        input_point_layer,
        output_point_layer,
        output_schema,
        output_raster_field,
    )
    # total = target_layer.GetFeatureCount()

    # Preset raster values
    p, a, b, q, c, d = geo_transform
    e, f, g, h = get_inverse(a, b, c, d)

    # count voor progress bar en
    # loopen over alle features om de dem value te updaten
    for count, feature in enumerate(target_layer):
        geom = feature.GetGeometryRef()

        # get point data
        x, y = geom.GetX(), geom.GetY()  # coord in map units

        # cast to integer indices
        j = np.int64(e * (x - p) + f * (y - q))
        i = np.int64(g * (x - p) + h * (y - q))

        # try & except used to set put buiten DEM extent to -9999 (nodatavalue)
        try:
            # uitlezen van raster op basis van pixel nummer
            arrayval = raster_band.ReadAsArray(int(j), int(i), 1, 1).astype(np.float)
            # gelezen waarde uit te pakken
            val = round(arrayval[0][0], 2)
        except:
            val = raster_band.GetNoDataValue()

        feature.SetField(str(output_raster_field), val)
        target_layer.SetFeature(feature)

        # progress bar progresses
        # ogr.TermProgress_nocb((count + 1) / total)

    conn.Destroy()
    pass


def get_inverse(a, b, c, d):
    """
    Return inverse for a 2 x 2 matrix
    with elements (a, b), (c, d).
    """
    D = 1 / (a * d - b * c)
    return d * D, -b * D, -c * D, a * D


def create_empty_point_sample_layer(
    settings, conn, input_point_layer, output_point_layer, output_schema, raster_field
):
    copy2pg_database(
        settings, conn, input_point_layer, output_point_layer, schema=output_schema
    )
    target_layer = conn.GetLayerByName("src." + output_point_layer)

    target_field = ogr.FieldDefn(str(raster_field), ogr.OFTReal)
    target_layer.CreateField(target_field)
    return target_layer
