-------------------------------------------------------------------------------------------
--- gisib TO 3Di (currently manholes and pipes only)
--- Input: Export of gisib (vrijv_leiding.shp and rioolput.shp)
--- Output: 3Di model in work_db
-------------------------------------------------------------------------------------------

-------------------------------------------------
------ Stap 0: Data inladen ---------------------
-------------------------------------------------
/* Used in other scripts
-- import gisib files with ogr2ogr
CREATE SCHEMA gisib;
-- Open OSGEO4W shell and navigate to your folder (cd)
for %f in (*.shp) do (ogr2ogr -overwrite -skipfailures -f "PostgreSQL" PG:"host=<hostname> user=<username> dbname=<databasename> password=<password> port=5432" -lco GEOMETRY_NAME=geom -lco FID="id" -nln gisib.%~nf %f -a_srs EPSG:28992)

-- Error and Answer:
-- UTF8 issues -> resave shapefile with UTF8 encoding on in QGIS

-- CHECK EXPECTED FILES ON CORRECT NUMBER OF PUTTEN EN LEIDINGEN
SELECT * FROM src.putten_gisib LIMIT 10;
SELECT * FROM src.leidingen_gisib LIMIT 10;
SELECT count(*) FROM src.putten_gisib;
SELECT count(*) FROM src.leidingen_gisib;
*/

ALTER TABLE src.putten_gisib
	ADD COLUMN IF NOT EXISTS naam VARCHAR(255);

-------------------------------------------------
------ Stap 1: connection-nodes toevoegen -------
-------------------------------------------------
INSERT INTO v2_connection_nodes (id, storage_area, code, the_geom)
	SELECT
		id::integer as id,
		NULL as storage_area, -- use guess_indicators
		COALESCE(naam, naam_of_nu,'leeg') as code,
		ST_SetSRID(st_force2d(geom), 28992) as the_geom
	FROM src.putten_gisib;

-------------------------------------------------
---------- Stap 2: manholes toevoegen -----------
-------------------------------------------------
DELETE FROM v2_manhole;
INSERT INTO v2_manhole(
			id, display_name, code, connection_node_id, shape, width, length,
			manhole_indicator,bottom_level, surface_level, drain_level, zoom_category)
SELECT
	id::integer as id,
	COALESCE(naam, naam_of_nu,'leeg') as display_name,
	COALESCE(naam, naam_of_nu,'leeg') as code,
	id as connection_node_id,
	CASE
		WHEN lower(vorm_knoop) LIKE '%vierkant%' THEN 'sqr' -- not supported by GWSW, just to be sure
		WHEN lower(vorm_knoop) LIKE '%rond%' THEN 'rnd'
		WHEN lower(vorm_knoop) LIKE '%rechthoekig%' THEN 'rect'
		ELSE NULL
	END AS shape,
	(CASE
		WHEN lower(vorm_knoop) LIKE '%vierkant%' THEN COALESCE(breedte_pu,breedte_01)
		WHEN lower(vorm_knoop) LIKE '%rond%' THEN COALESCE(diameter,breedte_pu)
		WHEN lower(vorm_knoop) LIKE '%rechthoekig%' THEN COALESCE(breedte_pu,breedte_01)
		ELSE COALESCE(breedte_pu,breedte_01)
	END)::numeric AS width,
	(CASE
		WHEN lower(vorm_knoop) LIKE '%vierkant%' THEN COALESCE(breedte_01,breedte_pu)
		WHEN lower(vorm_knoop) LIKE '%rond%' THEN COALESCE(diameter,breedte_01)
		WHEN lower(vorm_knoop) LIKE '%rechthoekig%' THEN COALESCE(breedte_01,breedte_pu)
		ELSE COALESCE(breedte_01,breedte_pu)
	END)::numeric AS length,
	CASE
		WHEN lower(type_knoop) LIKE '%overstort%' THEN 4  -- not supported by 3Di
		WHEN lower(type_knoop) LIKE '%inprik%' THEN 3
		WHEN lower(type_knoop) LIKE '%pomp%' THEN 2
		WHEN lower(type_knoop) LIKE '%uitlaat%' THEN 1
		ELSE 0
	END AS manhole_indicator,
	(replace(straatpeil,',','.')::double precision) - putbodem AS bottom_level,
	replace(straatpeil,',','.')::double precision AS surface_level,
	NULL AS drain_level,
	1 AS zoom_category
FROM src.putten_gisib;