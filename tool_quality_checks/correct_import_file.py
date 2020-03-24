# -*- coding: utf-8 -*-
"""
Import OGR Datasource into the database
"""

import ogr
import osr
import logging

DRIVER_OGR_MEM = ogr.GetDriverByName("Memory")
_mem_num = 0

logger = logging.getLogger(__name__)
ogr.UseExceptions()


def create_mem_ds():
    """ Creating an ogr datasource in memory"""
    global _mem_num
    mem_datasource = DRIVER_OGR_MEM.CreateDataSource("/vsimem/mem{}".format(_mem_num))
    _mem_num = _mem_num + 1
    return mem_datasource


def create_geom_transform(in_spatial_ref, out_epsg):
    """Return coordinate transformation based on two reference systems"""
    out_spatial_ref = osr.SpatialReference()
    out_spatial_ref.ImportFromEPSG(out_epsg)
    coordTrans = osr.CoordinateTransformation(in_spatial_ref, out_spatial_ref)
    return coordTrans


def transform_multipart_to_singlepart(in_layer, out_layer):
    """
    Load the current geometries and write them to singleparts in a new layer
            
        INPUT: in_layer, out_layer
        OUTPUT: out_layer, lost_features
    """
    lost_features = []
    layer_defn = in_layer.GetLayerDefn()
    field_names = []
    for n in range(layer_defn.GetFieldCount()):
        field_names.append(layer_defn.GetFieldDefn(n).name)

    for count, in_feat in enumerate(in_layer):
        content = {}
        for field_name in field_names:
            content[field_name] = in_feat.GetField(field_name)

        geom = in_feat.GetGeometryRef()
        if geom == None:
            logger.warning("FID {} has no geometry.".format(count))
            lost_features.append(in_feat.GetFID())
            continue

        if (
            geom.GetGeometryName() == "MULTIPOLYGON"
            or geom.GetGeometryName() == "MULTILINESTRING"
            or geom.GetGeometryName() == "MULTIPOINT"
        ):
            for geom_part in geom:
                add_singlepart_geometry(geom_part.ExportToWkb(), content, out_layer)
        else:
            add_singlepart_geometry(geom.ExportToWkb(), content, out_layer)

    return out_layer, lost_features


def add_singlepart_geometry(in_geometry, content, out_lyr):
    """
    Add a new geometry with content to your out layer
    """
    featureDefn = out_lyr.GetLayerDefn()

    geometry = ogr.CreateGeometryFromWkb(in_geometry)
    out_feat = ogr.Feature(featureDefn)
    out_feat.SetGeometry(geometry)

    for key, value in content.items():
        out_feat.SetField(key, value)

    out_lyr.CreateFeature(out_feat)


def try_fix_geometry(geometry):
    """
    Tries to fix a geometry.
    If it does not work, give it back with False
    If it works give it back with True

    Input: geometry
    Output: fixed geometry with true or original geometry with false
    """
    # if a statement is used for dissolving or clipping, none geometry could be entered
    if geometry is None:
        return None, False

    geom_name = geometry.GetGeometryName()
    # check pointcount if linestring
    if "LINESTRING" in geom_name:
        if geometry.GetPointCount() == 1:
            logger.warning("Geometry point count of linestring = 1")
            return geometry, False
        else:
            pass

    # solve self intersections
    if "POLYGON" in geom_name:
        try:
            geometry = geometry.Buffer(0)
        except Exception as e:
            # RuntimeError: IllegalArgumentException: Points of LinearRing do not form a closed linestring
            logger.warning(e)
            return geometry, False

    # We think this part is not used or creates an error. So just leave it out for a while
    # # check slivers
    # if not geometry.IsValid():
    #     perimeter = geometry.Boundary().Length()
    #     area = geometry.GetArea()

    #     sliver = float(perimeter / area)

    #     if sliver < 1:
    #         wkt = geometry.ExportToWkt()
    #         geometry = ogr.CreateGeometryFromWkt(wkt)

    return geometry, geometry.IsValid()


def correct_layer_name_length(layer_name):
    logger.info("check - Name length")
    if len(layer_name) + 10 > 64:
        logger.warning("laagnaam te lang, 50 characters max.")
        logger.warning("formatting naar 50 met deze naam: %s" % layer_name[:50])
        layer_name = layer_name[:50]
    return layer_name


def correct_vector_layer(in_layer, layer_name="", epsg=3857):
    """
        This function standardizes a vector layer:
            1. Multipart to singleparts
            2. 3D polygon to 2D polygon
            3. Reprojection
            4. Fix for self intersections
            
        INPUT: layer, layer_name
        OUTPUT: out_datasource, layer_name
      """

    # retrieving lost features
    lost_features = []
    in_feature_count = in_layer.GetFeatureCount()

    # Get inspatial reference and geometry from in shape
    geom_type = in_layer.GetGeomType()
    in_spatial_ref = in_layer.GetSpatialRef()
    in_layer.ResetReading()

    layer_name = layer_name.lower()
    layer_name = correct_layer_name_length(layer_name)

    # Create output dataset and force dataset to multiparts
    # variable output_geom_type, does it always work? if not add check
    geom_name = ogr.GeometryTypeToName(geom_type)
    if "polygon" in geom_name.lower():
        output_geom_type = 3  # polygon
    elif "line" in geom_name.lower():
        output_geom_type = 2  # linestring
    elif "point" in geom_name.lower():
        output_geom_type = 1  # point
    else:
        logger.error("Geometry could not be translated to singlepart %s" % geom_name)
        raise TypeError()

    # create memory datasource for
    mem_datasource = create_mem_ds()
    mem_layer = mem_datasource.CreateLayer(layer_name, in_spatial_ref, output_geom_type)

    # create datasource output
    out_datasource = create_mem_ds()
    spatial_ref_out = osr.SpatialReference()
    spatial_ref_out.ImportFromEPSG(int(epsg))
    out_layer = out_datasource.CreateLayer(
        layer_name, spatial_ref_out, output_geom_type
    )

    layer_defn = in_layer.GetLayerDefn()
    for i in range(layer_defn.GetFieldCount()):
        field_defn = layer_defn.GetFieldDefn(i)
        mem_layer.CreateField(field_defn)

    logger.info("check - Multipart to singlepart")
    mem_layer, additional_lost_features = transform_multipart_to_singlepart(
        in_layer, mem_layer
    )
    lost_features = lost_features + additional_lost_features

    if mem_layer.GetFeatureCount() == 0:
        logger.warning("Multipart to singlepart failed")
        raise TypeError()

    flatten = False
    if "3D" in geom_name:
        logger.warning("geom type: " + geom_name)
        logger.info("Flattening to 2D")
        flatten = True
    elif geom_type <= 0:
        logger.error("Geometry invalid, please fix it first, type is: %s" % geom_name)
        raise TypeError()

    # Copy fields from memory layer to output dataset
    layer_defn = in_layer.GetLayerDefn()
    for i in range(layer_defn.GetFieldCount()):
        out_layer.CreateField(layer_defn.GetFieldDefn(i))

    logger.info("check - Reproject layer to {}".format(str(epsg)))
    reproject = osr.CoordinateTransformation(in_spatial_ref, spatial_ref_out)
    for out_feat in mem_layer:
        out_geom = out_feat.GetGeometryRef()
        out_geom, valid = try_fix_geometry(out_geom)

        if not valid:
            logger.warning("geometry invalid even with buffer, skipping")
            lost_features.append(out_feat.GetFID())
            continue

        # Transform geometry
        out_geom.Transform(reproject)

        # flattening to 2d
        if flatten:
            out_geom.FlattenTo2D()

        # Set geometry and create feature
        out_feat.SetGeometry(out_geom)
        out_layer.CreateFeature(out_feat)

    logger.info("check  - delete ogc_fid if exists")
    out_layer_defn = out_layer.GetLayerDefn()
    for n in range(out_layer_defn.GetFieldCount()):
        field = out_layer_defn.GetFieldDefn(n)
        if field.name == "ogc_fid":
            out_layer.DeleteField(n)
            break

    logger.info("check  - Features count")
    out_feature_count = out_layer.GetFeatureCount()

    if len(lost_features) > 0:
        logger.warning("Lost {} features during corrections".format(len(lost_features)))
        logger.warning("FIDS: {}".format(lost_features))
    elif in_feature_count > out_feature_count:
        logger.warning("In feature count greater than out feature count")

    mem_layer = None
    mem_datasource = None
    out_layer = None

    return out_datasource, layer_name
