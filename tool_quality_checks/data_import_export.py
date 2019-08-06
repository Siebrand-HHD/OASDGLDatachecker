# -*- coding: utf-8 -*-
""" TODO Docstring. 

original code from: https://github.com/francot/python-ogr-postgis-tools/blob/master/export_import_postgis_shp.py
"""


import sys
import os
import psycopg2
import psycopg2.extras
from osgeo import ogr
from osgeo import osr

dbname = '__'
user = '__'
password = '__'
host = '__'

connString = "PG: host=%s dbname=%s user=%s password=%s" %(host, dbname, user, password)
connString_pg = "dbname=%s user=%s password=%s  host=%s" %(dbname, user, password,  host)

###################### import from shp to pg ################################
#############################################################################

def GetFieldValueasDictFromOgrDatasource(path):
# return a Dictionary with shp field and values
    ds = ogr.Open(path)
    if path is None:
        print('Could not open %s' % path)
    else:
        layer = ds.GetLayer(0)
        lyrDefn = layer.GetLayerDefn()
        #this Dictionary store field name as keys and field type
        ds_field = {}
        for i in range(lyrDefn.GetFieldCount()):
            fieldName = lyrDefn.GetFieldDefn(i).GetName()
            fieldTypeCode = lyrDefn.GetFieldDefn(i).GetType()
            fieldType = lyrDefn.GetFieldDefn(i).GetFieldTypeName(fieldTypeCode)
            if fieldType=='String':
                fieldType='Varchar'
            fieldType
            ds_field[fieldName]=fieldType
        ds_records=[]
        for i in range(layer.GetFeatureCount()):
            if os.path.splitext(path)[1] == '.gpkg':
                i = i + 1
            elif os.path.splitext(path)[1] == '.shp':
                pass
            else:
                logger.warning("This file might not be supported: %s"% path)

            ds_values = {}
            for j in range(lyrDefn.GetFieldCount()):
                fieldName = lyrDefn.GetFieldDefn(j).GetName()
                feature = layer.GetFeature(i)
                value = feature.GetField(fieldName)
                wkt = feature.GetGeometryRef().ExportToWkt()
                ds_values[fieldName]=value
                ds_values['geom']=wkt
            #append in the vector all the ds records stored as Dictionary
            ds_records.append(ds_values)
        #insert in the first position of the vector the Dictionary with field type
        ds_records.insert(0,ds_field)
        return ds_records


def import_ogrdatasource_to_postgres(path, db): #, schema,table, srid):
    """
    Import OgrDatasource to pg
    tested is geopackage and shapefile
    """

    #Create Table using field type from the Dictionary
    FieldType = GetFieldValueasDictFromOgrDatasource(path)[0]
        
    # # TODO append or insert choice
    # sql_parameter = 'CREATE TABLE IF NOT EXISTS __s__.__t__ \n(' + ',\n '.join([str(i)+' '+str(v)  for i,v in FieldType.iteritems()]) + ',\n geom Geometry' + ')'
    #     sql = sql_parameter.replace('__s__',schema).replace('__t__',table)
    #     cur.execute("DROP TABLE test")
    #     cur.execute (sql)
    #     #Insert in the Table all the record from the Dictionary
    #     for i in range(1,len(GetFieldValueasDictFromOgrDatasource(path))):
    #         d=GetFieldValueasDictFromOgrDatasource(path)[i]
    #         field_name = ', '.join([str(i)  for i in d.keys()])
    #         value= ', '.join([str(repr(i)) for i in d.values()])  #### repr solve the string cast -- http://initd.org/psycopg/docs/usage.html#adapt-string
    #         sql= "INSERT INTO %s.%s (%s)" %(schema,table,field_name) + " VALUES (%s)" %(value)
    #         cur.execute(sql)
    #         # TODO pass srid as function output and Srid Transform
    #         sql = 'UPDATE %s.%s SET geom=ST_SetSrid(geom,%s)'%(schema,table,srid)
    #         cur.execute(sql)
    #     con.commit()
    #     print("Import Ok\n for shapefile: %s \n in table: %s.%s" % os.path.basename(path),schema,table)
    # except psycopg2.DatabaseError as e:
    #     if con:
    #         con.rollback()
    #     print('Error %s' % e)
    #     sys.exit(1)
    # finally:
    #     if con:
    #         con.close()

