# -*- coding: utf-8 -*-
""" 
Purpose to load OGR data like shapefiles into postgres
"""
import os
import logging
from osgeo import ogr
from os.path import basename
from OASDGLDatachecker.tool_quality_checks.correct_import_file import correct_vector_layer

logger = logging.getLogger(__name__)
ogr.UseExceptions()


# def importer(settings):

#     copy2pg_database(settings, settings., "test")

def copy2pg_database(settings, in_filepath, layer_name, schema="public"):
    datasource = set_ogr_connection_pg_database(settings)
    in_source = set_ogr_connection(in_filepath)
    in_name = os.path.splitext(basename(in_filepath))[0]
    in_layer = in_source.GetLayerByName(in_name)
    in_srid = in_layer.GetSpatialRef()

    # correct vector layer to solve issues and stuff
    correct_in_source, correct_layer_name = correct_vector_layer(in_layer, layer_name, epsg=28992)
    correct_in_layer = correct_in_source.GetLayerByName(correct_layer_name)
    
    # check projection of input file
    check_sr = get_projection(in_srid)
    if check_sr is None:
        logger.warning(
            "[!] Warning : Projection is not complete EPSG projection code missing in shapefile."
        )

    options = [
        "OVERWRITE=YES",
        "SCHEMA={}".format(schema),
        "SPATIAL_INDEX=GIST",
        "FID=id",
        "PRECISION=NO",
        "GEOMETRY_NAME=geom",
        "DIM=2",
    ]
    try:
        ogr.RegisterAll()
        # TODO srid is now based on in_layer, which could be a strange spatial reference
        # TODO findout how to make the target ref 28992 by default
        new_layer = datasource.CreateLayer(
            layer_name, correct_in_layer.GetSpatialRef(), correct_in_layer.GetGeomType(), options
        )
        for x in range(correct_in_layer.GetLayerDefn().GetFieldCount()):
            new_layer.CreateField(correct_in_layer.GetLayerDefn().GetFieldDefn(x))

        new_layer.StartTransaction()
        for x in range(correct_in_layer.GetFeatureCount()):
            new_feature = correct_in_layer.GetFeature(x)
            new_feature.SetFID(-1)
            new_layer.CreateFeature(new_feature)
            if x % 128 == 0:
                new_layer.CommitTransaction()
                new_layer.StartTransaction()
        new_layer.CommitTransaction()

    except Exception as e:
        logger.warning(e)
        raise

    if new_layer.GetFeatureCount() == 0:
        raise ValueError("Postgres vector feature count is 0")

    new_layer = None

    datasource.Destroy()
    in_source.Destroy()


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

    ogr_conn = ogr.Open(connection_path)
    if ogr_conn is None:
        raise ConnectionError("I am unable to read the file: %s" % connection_path)
    return ogr_conn
