# -*- coding: utf-8 -*-
"""Tests for fix_import_file.py"""
import os
import ogr, osr
import pytest

from OASDGLDatachecker.tool_quality_checks.fix_import_file import (
    create_mem_ds,
    create_geom_transform,
    try_fix_geometry,
    add_singlepart_geometry,
    transform_multipart_to_singlepart,
    fix_vector_layer,
    fix_layer_name_length,
)
from OASDGLDatachecker.tool_quality_checks.import_management_database import (
    set_ogr_connection,
)

OUR_DIR = os.path.dirname(__file__)
_shp_relpath = "data/rioolput.shp"
_shp_abspath = os.path.join(OUR_DIR, _shp_relpath)
_shp_in_ds = set_ogr_connection(_shp_abspath)
SHP_IN_LAYER = _shp_in_ds[0]

_gpkg_relpath = "data/fix_geometries.gpkg"
_gpkg_abspath = os.path.join(OUR_DIR, _gpkg_relpath)
GPKG_IN_DS = set_ogr_connection(_gpkg_abspath)


_sign_relpath = "data/sign.shp"
_sign_abspath = os.path.join(OUR_DIR, _sign_relpath)
_sign_in_ds = set_ogr_connection(_shp_abspath)
SIGN_IN_LAYER = _sign_in_ds[0]


def test_create_mem_ds():
    ds = create_mem_ds()
    assert isinstance(ds, ogr.DataSource)


def test_geom_transform():
    transform = create_geom_transform(SHP_IN_LAYER.GetSpatialRef(), 28992)
    assert isinstance(transform, osr.CoordinateTransformation)


def test_try_fix_geometry_valid():
    geom = ogr.Geometry(ogr.wkbLineString)
    geom.AddPoint(1116651.439379124, 637392.6969887456)
    geom.AddPoint(1188804.0108498496, 652655.7409537067)
    out_geom, valid = try_fix_geometry(geom)
    assert valid is True


def test_try_fix_geometry_none():
    line = None
    geom, valid = try_fix_geometry(line)
    assert valid is False


def test_try_fix_geometry_unvalid_line():
    line = ogr.Geometry(ogr.wkbLineString)
    line.AddPoint(1116651.439379124, 637392.6969887456)
    geom, valid = try_fix_geometry(line)
    assert valid is False


def test_try_fix_geometry_polygon_self_intersect():
    # Create ring
    ring = ogr.Geometry(ogr.wkbLinearRing)
    ring.AddPoint_2D(1, 1)
    ring.AddPoint_2D(1, -1)
    ring.AddPoint_2D(-1, 1)
    ring.AddPoint_2D(-1, -1)
    ring.AddPoint_2D(1, 1)

    # Create polygon
    poly = ogr.Geometry(ogr.wkbPolygon)
    poly.AddGeometry(ring)

    out_geom, valid = try_fix_geometry(poly)
    assert valid is True


def test_try_fix_geometry_polygon_sliver_not_valid():
    # Create ring
    wkt = "POLYGON ((0 0 0, 1000 0 0, 1000 0.001 0))"
    poly = ogr.CreateGeometryFromWkt(wkt)
    out_geom, valid = try_fix_geometry(poly)
    assert valid is False


def test_add_singlepart_geometry():
    # get random geom_typ and spatial ref
    output_geom_type = 3
    in_spatial_ref = SHP_IN_LAYER.GetSpatialRef()

    # create memory layer
    mem_datasource = create_mem_ds()
    mem_layer = mem_datasource.CreateLayer("test", in_spatial_ref, output_geom_type)
    layer_field = ogr.FieldDefn("name", ogr.OFTString)
    mem_layer.CreateField(layer_field)

    # Create ring
    ring = ogr.Geometry(ogr.wkbLinearRing)
    ring.AddPoint_2D(1, 1)
    ring.AddPoint_2D(1, -1)
    ring.AddPoint_2D(-1, 1)
    ring.AddPoint_2D(-1, -1)
    ring.AddPoint_2D(1, 1)

    # Create polygon
    poly = ogr.Geometry(ogr.wkbPolygon)
    poly.AddGeometry(ring)
    content = {"name": "my_polygon"}
    add_singlepart_geometry(poly.ExportToWkb(), content, mem_layer)
    test_dump = mem_layer.GetFeature(0).ExportToJson()
    assert "my_polygon" in test_dump
    assert "[[[1.0, 1.0], [1.0, -1.0]," in test_dump


def test_transform_multipart_to_singlepart():
    multipoly_in_layer = GPKG_IN_DS["multipolygon_4326"]
    # get random geom_typ and spatial ref
    geom_type = multipoly_in_layer.GetGeomType()
    in_spatial_ref = multipoly_in_layer.GetSpatialRef()

    # create memory layer
    mem_datasource = create_mem_ds()
    mem_layer = mem_datasource.CreateLayer("test", in_spatial_ref, geom_type)
    layer_defn = multipoly_in_layer.GetLayerDefn()
    for i in range(layer_defn.GetFieldCount()):
        field_defn = layer_defn.GetFieldDefn(i)
        mem_layer.CreateField(field_defn)

    mem_layer, lost_feat = transform_multipart_to_singlepart(
        multipoly_in_layer, mem_layer
    )
    test_dump = mem_layer.GetFeature(1).ExportToJson()
    assert '"coordinates": [[[4.358551040042' in test_dump
    assert lost_feat == [2]


def test_fix_layer_name_length_long():
    layer_name = "this_is_much_longer_than_what_should_be_the_length_of_the_layer"
    new_layer_name = fix_layer_name_length(layer_name)
    assert new_layer_name == "this_is_much_longer_than_what_should_be_the_length"


def test_fix_layer_name_length_short():
    layer_name = "this_is_short"
    new_layer_name = fix_layer_name_length(layer_name)
    assert new_layer_name == "this_is_short"


def test_fix_vector_layer_manholes_3D_point(caplog):
    out_datasource, layer_name = fix_vector_layer(SHP_IN_LAYER, "test", epsg=28992)
    assert "3D Point" in caplog.text
    assert out_datasource[layer_name].GetFeatureCount() == 79


def test_fix_vector_layer_multipoly(caplog):
    multipoly_in_layer = GPKG_IN_DS["multipolygon_4326"]
    out_datasource, layer_name = fix_vector_layer(
        multipoly_in_layer,
        "test_multi_met_veel_te_veel_tekens_in_de_naam_namelijk_meer_dan_vijftig_enzost_multi",
    )
    test_dump = (
        out_datasource["test_multi_met_veel_te_veel_tekens_in_de_naam_name"]
        .GetFeature(1)
        .ExportToJson()
    )
    assert '{"type": "Polygon", "coordinates": [[[485' in test_dump


def test_fix_vector_layer_empty_result(caplog):
    multipoly_in_layer = GPKG_IN_DS["no_geom_layer"]
    with pytest.raises(TypeError):
        fix_vector_layer(multipoly_in_layer, "test_empty", epsg=28992)


def test_fix_vector_layer_unknown_geom_type(caplog):
    multipoly_in_layer = GPKG_IN_DS["multipoint_in_geometrycollection"]
    with pytest.raises(TypeError):
        fix_vector_layer(
            multipoly_in_layer, "multipoint_in_geometrycollection", epsg=28992
        )


def test_fix_vector_layer_multipoints(caplog):
    # this test has a z-dimension
    multipoly_in_layer = GPKG_IN_DS["multipoint_28992"]
    out_datasource, layer_name = fix_vector_layer(
        multipoly_in_layer, "test_multipoint_28992", epsg=28992
    )
    test_dump = out_datasource["test_multipoint_28992"].GetFeature(1).ExportToJson()
    assert '{"type": "Point", "coordinates": [842' in test_dump


def test_fix_vector_layer_multilinestring(caplog):
    # this test has a z- and m-dimension and to be removed column name ogc_fid
    multipoly_in_layer = GPKG_IN_DS["multilinestring_zm_4326"]
    out_datasource, layer_name = fix_vector_layer(
        multipoly_in_layer, "test_multilinestring_zm_4326", epsg=28992
    )
    test_dump = (
        out_datasource["test_multilinestring_zm_4326"].GetFeature(1).ExportToJson()
    )
    assert '"type": "LineString", "coordinates": [[84' in test_dump


def test_fix_vector_layer_more_in_than_out(caplog):
    multipoly_in_layer = GPKG_IN_DS["more_in_than_out_polygon"]
    out_datasource, layer_name = fix_vector_layer(
        multipoly_in_layer, "more_in_than_out_polygon", epsg=28992
    )
    assert "In feature count greater than out" in caplog.text


def test_special_characters():
    in_spatial_ref = SIGN_IN_LAYER.GetSpatialRef()
    mem_datasource = create_mem_ds()
    mem_layer = mem_datasource.CreateLayer("", in_spatial_ref, ogr.wkbPoint)

    layer_defn = SIGN_IN_LAYER.GetLayerDefn()
    for i in range(layer_defn.GetFieldCount()):
        field_defn = layer_defn.GetFieldDefn(i)
        mem_layer.CreateField(field_defn)

    feature = SIGN_IN_LAYER[0]
    geom = feature.GetGeometryRef()
    content = feature.items()

    add_singlepart_geometry(geom.ExportToWkb(), content, mem_layer)

    assert mem_layer.GetFeatureCount() == 1
