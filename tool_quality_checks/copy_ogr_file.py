# -*- coding: utf-8 -*-
""" 
Purpose to load OGR data like shapefiles into postgres
"""
import os
import logging
from osgeo import ogr
from OASDGLDatachecker.tool_quality_checks.correct_import_file import (
    correct_vector_layer,
)

logger = logging.getLogger(__name__)
ogr.UseExceptions()
OUR_DIR = os.path.dirname(__file__)


def copy2ogr(in_source, in_name, out_source, out_name, schema="public"):
    """
        copy an ogr datasource, like ESRI shapefile, to the database
    """

    # currently only working for shapefile
    # TODO change naming to also include sqlite and gpkg
    in_layer = in_source.GetLayerByName(in_name)
    if in_layer is None:
        logger.error("I could not find the table in your datasource:", in_name)
        raise AttributeError()
    in_srid = in_layer.GetSpatialRef()

    # correct vector layer to solve issues and stuff
    # correct_in_source, correct_layer_name = in_layer, out_name
    corrected_in_source, corrected_layer_name = correct_vector_layer(
        in_layer, out_name, epsg=28992
    )
    corrected_in_layer = corrected_in_source.GetLayerByName(corrected_layer_name)

    # check projection of input file
    check_sr = get_projection(in_srid)
    if check_sr is None:
        logger.warning(
            "[!] Warning : Projection is not complete EPSG projection code missing in shapefile."
        )

    # correct vector layer to solve issues and stuff
    # correct_in_source, correct_layer_name = in_layer, out_name
    corrected_in_source, corrected_layer_name = correct_vector_layer(
        in_layer, out_name, epsg=28992
    )
    corrected_in_layer = corrected_in_source.GetLayerByName(corrected_layer_name)

    options = [
        "OVERWRITE=YES",
        "SCHEMA={}".format(schema),
        "SPATIAL_INDEX=GIST",
        # try to comment row below when running to transaction block error
        "FID=id",
        "PRECISION=NO",
        "GEOMETRY_NAME=geom",
        "DIM=2",
    ]

    ogr.RegisterAll()
    # TODO srid is now based on in_layer, which could be a strange spatial reference
    # TODO findout how to make the target ref 28992 by default
    new_layer = out_source.CreateLayer(
        corrected_layer_name,
        corrected_in_layer.GetSpatialRef(),
        corrected_in_layer.GetGeomType(),
        options,
    )
    for i in range(corrected_in_layer.GetLayerDefn().GetFieldCount()):
        new_layer.CreateField(corrected_in_layer.GetLayerDefn().GetFieldDefn(i))

    new_layer.StartTransaction()
    for j in range(corrected_in_layer.GetFeatureCount()):
        new_feature = corrected_in_layer.GetFeature(j)
        new_feature.SetFID(-1)
        new_layer.CreateFeature(new_feature)
        if j % 128 == 0:
            new_layer.CommitTransaction()
            new_layer.StartTransaction()
    new_layer.CommitTransaction()

    if new_layer.GetFeatureCount() == 0:
        raise ValueError("Postgres vector feature count is 0")

    new_layer = None


def get_projection(sr):
    """ Return simple userinput string for spatial reference, if any. """
    key = str("GEOGCS") if sr.IsGeographic() else str("PROJCS")
    name, code = sr.GetAuthorityName(key), sr.GetAuthorityCode(key)
    if name is None or code is None:
        return None
    return "{name}:{code}".format(name=name, code=code)


def set_ogr_connection_pg_database(settings):
    """ Establishes the db connection. """
    db_conn = (
        "PG: dbname={dbname_value} user={user_value} "
        "host={host_value} password={password_value}".format(
            dbname_value=settings.database,
            user_value=settings.username,
            host_value=settings.host,
            password_value=settings.password,
        )
    )
    return set_ogr_connection(db_conn)


def set_ogr_connection(connection_path):
    """ Establishes the db connection. """
    # Connect met de database

    ogr_conn = ogr.Open(connection_path, 1)
    if ogr_conn is None:
        raise ConnectionError("I am unable to read the file: %s" % connection_path)
    return ogr_conn
