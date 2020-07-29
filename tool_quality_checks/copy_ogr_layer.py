# -*- coding: utf-8 -*-
""" 
Purpose to load OGR data like shapefiles into postgres
"""
import os
import logging
from osgeo import ogr, osr
from OASDGLDatachecker.tool_quality_checks.fix_import_file import (
    fix_vector_layer,
    fix_layer_name_length,
)

logger = logging.getLogger(__name__)
ogr.UseExceptions()
OUR_DIR = os.path.dirname(__file__)


def copy2ogr(in_source, in_name, out_source, out_name, schema="public"):
    """
        copy an ogr datasource, like ESRI shapefile, to an ogr datasource
    """

    # currently only working for shapefile
    # TODO change naming to also include sqlite and gpkg
    # define input layer here
    in_layer = in_source.GetLayerByName(in_name)
    if in_layer is None:
        msg = "I could not find the table in your datasource: %s" % in_name
        raise ValueError(msg)

    in_srid = in_layer.GetSpatialRef()

    # TODO insert check if layer has a geometry inside, maybe this is not needed due to featurecount added
    # if in_srid is None:
    #     logger.warning("Input layer has no geometry column: %s" % in_name)
    #     has_geom = False
    if in_layer.GetFeatureCount() == 0:
        logger.warning("Input feature count is 0 for layer: %s" % in_name)
        has_geom = False
    elif in_layer.GetNextFeature().geometry() == None:
        logger.warning("Input layer has no geometry column: %s" % in_name)
        has_geom = False
    else:
        has_geom = True

    if has_geom:
        # check projection of input file
        if in_srid is None:
            in_srid = predict_projection(in_layer.GetExtent())
        else:
            check_sr = get_projection(in_srid)
            if check_sr is None:
                logger.warning(
                    "[!] Warning : Projection is not complete EPSG projection code missing in shapefile."
                )

        # correct vector layer to solve issues and stuff
        # fix_in_source, fix_layer_name = in_layer, out_name
        fixed_in_source, fixed_layer_name = fix_vector_layer(
            in_layer, out_name, 28992, in_srid
        )
        fixed_in_layer = fixed_in_source.GetLayerByName(fixed_layer_name)

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
            fixed_layer_name,
            srs=fixed_in_layer.GetSpatialRef(),
            geom_type=fixed_in_layer.GetGeomType(),
            options=options,
        )
    else:
        fixed_layer_name = fix_layer_name_length(out_name)
        fixed_in_layer = in_layer

        options = [
            "OVERWRITE=YES",
            "SCHEMA={}".format(schema),
            # try to comment row below when running to transaction block error
            "FID=id",
            "PRECISION=NO",
        ]

        new_layer = out_source.CreateLayer(fixed_layer_name, options=options)

    field_names = []
    fixed_layer_definition = fixed_in_layer.GetLayerDefn()
    for i in range(fixed_layer_definition.GetFieldCount()):
        if fixed_layer_definition.GetFieldDefn(i).GetName() == "ID":
            fixed_layer_definition.GetFieldDefn(i).SetType(
                ogr.OFTInteger
            )  # fix error ID field type verkeerd
        new_layer.CreateField(fixed_layer_definition.GetFieldDefn(i))
        field_names.append(fixed_layer_definition.GetFieldDefn(i).GetName())

    new_layer.StartTransaction()

    fixed_in_layer.ResetReading()
    for j, copy_feature in enumerate(fixed_in_layer):
        # copy_feature = fixed_in_layer.GetFeature(j)
        copy_feature.SetFID(-1)

        new_feature = ogr.Feature(new_layer.GetLayerDefn())
        new_feature.SetFID(-1)
        for key in field_names:
            new_feature[key] = copy_feature[key]
        if has_geom:
            new_geom = copy_feature.geometry()
            new_feature.SetGeometry(new_geom)
        new_layer.CreateFeature(new_feature)
        if j % 128 == 0:
            new_layer.CommitTransaction()
            new_layer.StartTransaction()
    new_layer.CommitTransaction()

    if new_layer.GetFeatureCount() == 0 and in_layer.GetFeatureCount() > 0:
        raise ValueError(
            "Output feature count is 0, while input is not, in layer:",
            new_layer.GetName(),
            "Input nr features:",
            in_layer.GetFeatureCount(),
            "Output nr features:",
            new_layer.GetFeatureCount(),
        )

    new_layer = None  # used to close and save the new_layer


def predict_projection(bbox):
    """ Return epsg based on y coordinates"""
    minx, maxx, miny, maxy = bbox
    if miny > 285000 and miny < 628000:
        epsg = 28992
    elif miny > 6500000 and miny < 7200000:
        epsg = 3857
    elif miny > 50 and miny < 53:
        epsg = 4326
    else:
        logger.warning("[!] Warning : Projection cannot be predicted by y coordinate")
        return None
    logger.info("[!] Info : predicted projecion as EPSG:{}".format(str(epsg)))
    sr = osr.SpatialReference()
    sr.ImportFromEPSG(epsg)
    return sr


def get_projection(sr):
    """ Return simple userinput string for spatial reference, if any. """
    key = str("GEOGCS") if sr.IsGeographic() else str("PROJCS")
    name, code = sr.GetAuthorityName(key), sr.GetAuthorityCode(key)
    if name is None or code is None:
        return None
    return "{name}:{code}".format(name=name, code=code)


def has_columns(in_path, columns, check_geom=True):
    """ Return true if columns and geometry in file. """
    in_source = set_ogr_connection(in_path)
    names = [i.name for i in in_source[0].schema]
    has_columns = len([n for n in names if n in columns]) == len(columns)

    if check_geom:
        layer = in_source[0]
        has_geom = isinstance(layer[0].geometry(), ogr.Geometry)
        has_columns = has_columns and has_geom

    in_source = None
    return has_columns


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
