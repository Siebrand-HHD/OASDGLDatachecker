from osgeo import ogr

ogr.UseExceptions()
input_datasource = ogr.GetDriverByName("ESRI Shapefile").Open(
    "C:\\Users\\arnold.vantveld\\Documents\\GitHub\\OASDGLDatachecker\\tool_quality_checks\\test\\data\\rioolput.shp"
)
input_layer = input_datasource.GetLayerByIndex(0)

dataset_options = ["VERSION=1.2"]


# UNCOMMENT
output_datasource = ogr.GetDriverByName("GPKG").CreateDataSource(
    "C:\\Users\\arnold.vantveld\\Documents\\GitHub\\OASDGLDatachecker\\tool_quality_checks\\test\\data\\tmp.gpkg",
    dataset_options,
)

# COMMENT
# output_datasource = ogr.GetDriverByName('ESRI Shapefile').CreateDataSource("C:\\Users\\arnold.vantveld\\Documents\\GitHub\\OASDGLDatachecker\\tool_quality_checks\\test\\data\\tmp.shp")


output_layer = output_datasource.CreateLayer(
    "output_layer",
    input_layer.GetSpatialRef(),
    input_layer.GetGeomType(),
    ["SPATIAL_INDEX=NO", "FID=ID"],
)

# # 1- Copying the old layer schema into the new layer
# defn = input_layer.GetLayerDefn()
# output_layer.CreateField(ogr.FieldDefn("id", ogr.OFTInteger64))
# output_layer.CreateField(ogr.FieldDefn("name", ogr.OFTString))

# defn = output_layer.GetLayerDefn()
# for i in range(defn.GetFieldCount()):
#     print(defn.GetFieldDefn(i).GetType())
#     #print("Integer: ", ogr.OFTInteger64 )

# 2 - Copying the old layer schema into the new layer
field_names_list = []
defn = input_layer.GetLayerDefn()
for i in range(defn.GetFieldCount()):
    output_layer.CreateField(defn.GetFieldDefn(i))
    field_names_list.append(defn.GetFieldDefn(i).GetName())

# # 1- option working
# feat = ogr.Feature(output_layer.GetLayerDefn())
# print(feat)
# print(feat.ExportToJson(), feat.GetFieldCount())
# feat["id"] = 3
# feat["name"] = 'hoi'
# feat.SetGeometry(ogr.CreateGeometryFromWkt('POINT(241425.24978822045 483656.7801318023)'))
# output_layer.CreateFeature(feat)
# print(feat.ExportToJson(), feat.GetFieldCount())

# 2- Copying the features - not working
for copy_feat in input_layer:
    copy_feat.SetFID(-1)
    new_feat = ogr.Feature(output_layer.GetLayerDefn())
    for key in field_names_list:
        new_feat[key] = copy_feat[key]
    new_geom = copy_feat.geometry()
    new_feat.SetGeometry(new_geom)
    new_feat.SetFID(-1)
    # print(new_feat)
    # print(new_feat.ExportToJson(), new_feat.GetFieldCount())
    output_layer.CreateFeature(new_feat)
    # print(new_feat.ExportToJson(), new_feat.GetFieldCount())


output_layer = None
output_datasource = None
