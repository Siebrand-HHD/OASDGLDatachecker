-------------------------------------------------------------------------------------------
--- GBI TO 3Di (currently manholes and pipes only)
--- Input: Export of GBI (vrijv_leiding.shp and rioolput.shp)
--- Output: 3Di model in work_db
-------------------------------------------------------------------------------------------

-------------------------------------------------
------ Stap 0: Data inladen ---------------------
-------------------------------------------------
/* Used in other scripts
-- import GBI files with ogr2ogr
CREATE SCHEMA gbi;
-- Open OSGEO4W shell and navigate to your folder (cd)
for %f in (*.shp) do (ogr2ogr -overwrite -skipfailures -f "PostgreSQL" PG:"host=<hostname> user=<username> dbname=<databasename> password=<password> port=5432" -lco GEOMETRY_NAME=geom -lco FID="id" -nln gbi.%~nf %f -a_srs EPSG:28992)

-- Error and Answer:
-- UTF8 issues -> resave shapefile with UTF8 encoding on in QGIS

-- CHECK EXPECTED FILES ON CORRECT NUMBER OF PUTTEN EN LEIDINGEN
SELECT * FROM src.putten_gbi LIMIT 10;
SELECT * FROM src.leidingen_gbi LIMIT 10;
SELECT count(*) FROM src.putten_gbi;
SELECT count(*) FROM src.leidingen_gbi;
*/
-------------------------------------------------
------ Stap 1: connection-nodes toevoegen -------
-------------------------------------------------
INSERT INTO v2_connection_nodes (id, storage_area, code, the_geom)
	SELECT
		id,
		NULL as storage_area, -- use guess_indicators
		putcode as code,
		ST_SetSRID(st_force2d(geom), 28992) as the_geom
	FROM src.putten_gbi;

SELECT * FROM v2_connection_nodes;
SELECT COUNT(*) FROM v2_connection_nodes;
SELECT COUNT(DISTINCT code) FROM v2_connection_nodes;

-------------------------------------------------
---------- Stap 2: manholes toevoegen -----------
-------------------------------------------------
SELECT putafmetin, CASE
		WHEN lower(putafmetin) LIKE '%vierkant%' THEN 'sqr'
		WHEN lower(putafmetin) LIKE '%rond%' THEN 'rnd'
		WHEN lower(putafmetin) LIKE '%rechthoekig%' THEN 'rect'
		ELSE NULL END, COUNT(*) FROM src.putten_gbi GROUP BY putafmetin LIMIT 10;

SELECT * FROM v2_manhole WHERE shape IS NOT NULL LIMIT 10;
DELETE FROM v2_manhole;
INSERT INTO v2_manhole(
			id, display_name, code, connection_node_id, shape, width, length,
			manhole_indicator,bottom_level, surface_level, drain_level, zoom_category)
SELECT
	id as id,
	putcode AS display_name,
	putcode AS code,
	id as connection_node_id,
	CASE
		WHEN lower(vorm_gwsw) LIKE '%vierkant%' THEN 'sqr' -- not supported by GWSW, just to be sure
		WHEN lower(vorm_gwsw) LIKE '%rond%' THEN 'rnd'
		WHEN lower(vorm_gwsw) LIKE '%rechthoekig%' THEN 'rect'
		ELSE NULL
	END AS shape,
	(CASE
		WHEN lower(vorm_gwsw) LIKE '%vierkant%' THEN COALESCE(breedte,diameter)
		WHEN lower(vorm_gwsw) LIKE '%rond%' THEN COALESCE(diameter,breedte)
		WHEN lower(vorm_gwsw) LIKE '%rechthoekig%' THEN COALESCE(breedte,diameter)
		ELSE COALESCE(breedte,diameter)
	END)::numeric/1000.0 AS width,
	(CASE
		WHEN lower(vorm_gwsw) LIKE '%vierkant%' THEN COALESCE(lengte,diameter)
		WHEN lower(vorm_gwsw) LIKE '%rond%' THEN COALESCE(diameter,lengte)
		WHEN lower(vorm_gwsw) LIKE '%rechthoekig%' THEN COALESCE(lengte,diameter)
		ELSE COALESCE(lengte,diameter)
	END)::numeric/1000.0 AS length,
	CASE
		WHEN lower(std_rioolp) LIKE '%inprikpunt%' THEN 3
		WHEN lower(std_rioolp) LIKE '%gemaal%' THEN 2
		WHEN lower(std_rioolp) LIKE '%uitlaat%' THEN 1
		ELSE 0
	END AS manhole_indicator,
	diepte AS bottom_level,
	maaiveldho AS surface_level,
	NULL AS drain_level,
	1 AS zoom_category
FROM src.putten_gbi;
