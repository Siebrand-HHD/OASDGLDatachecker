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
		COALESCE(putcode,'0') as code,
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
	COALESCE(putcode,'0') AS display_name,
	COALESCE(putcode,'0') AS code,
	id as connection_node_id,
	CASE
		WHEN lower(putafmetin) LIKE '%vierkant%' THEN 'sqr'
		WHEN lower(putafmetin) LIKE '%rond%' THEN 'rnd'
		WHEN lower(putafmetin) LIKE '%rechthoekig%' THEN 'rect'
		ELSE NULL
	END AS shape,
	(CASE
		WHEN lower(putafmetin) LIKE '%vierkant%' THEN COALESCE(breedte,diameter)
		WHEN lower(putafmetin) LIKE '%rond%' THEN COALESCE(diameter,breedte)
		WHEN lower(putafmetin) LIKE '%rechthoekig%' THEN COALESCE(breedte)
		ELSE COALESCE(breedte,diameter)
	END)::numeric/1000.0 AS width,
	(CASE
		WHEN lower(putafmetin) LIKE '%vierkant%' THEN COALESCE(lengte,diameter)
		WHEN lower(putafmetin) LIKE '%rond%' THEN COALESCE(diameter,lengte)
		WHEN lower(putafmetin) LIKE '%rechthoekig%' THEN COALESCE(lengte,diameter)
		ELSE COALESCE(lengte,diameter)
	END)::numeric/1000.0 AS length,
	CASE
		WHEN lower(rioolputty) LIKE '%gemaal%' OR lower(std_rioolp) LIKE '%gemaal%' THEN 2
		WHEN lower(rioolputty) LIKE '%uitlaat%' OR lower(std_rioolp) LIKE '%uitlaat%' THEN 1
		ELSE 0
	END AS manhole_indicator,
	putdiepte AS bottom_level,
	maaiveldho AS surface_level,
	NULL AS drain_level,
	1 AS zoom_category
FROM src.putten_gbi;
--WHERE aanlegjaar != 9999;

-------------------------------------------------
-------- Stap 3: Leidingen invoeren -------
-------------------------------------------------



-- CHECK OF AL JOUW materialen, strengtype etc voorkomen!!
DELETE FROM v2_pipe;
DELETE FROM v2_cross_section_definition;
INSERT INTO v2_cross_section_definition(id, shape, width, height, code)
VALUES (1, 1, 10, 1, 'tmp');

INSERT INTO v2_pipe(
            id, display_name, code, sewerage_type,
            invert_level_start_point, invert_level_end_point, cross_section_definition_id,
            material, original_length, zoom_category, connection_node_start_id, connection_node_end_id)
SELECT
	a.id 		AS id,
	COALESCE(s.putcode,'0') || '_' || COALESCE(e.putcode,'0')	AS display_name,
	COALESCE(s.putcode,'0') || '_' || COALESCE(e.putcode,'0')	AS code,
	CASE
		--We achten stelseltyp het belangrijkste, alleen als dit geen uitsluitsel geeft over het sewerage_type zullen andere kolommen worden gebruikt: std_stelse 
        --strengtype kunstwerken--
        WHEN lower(strengtype) LIKE '%berg%'		                                                                                           THEN 7 -- BERGBEZINKVOORZIENING
		WHEN lower(strengtype) LIKE '%overstort%'   		                                                                                   THEN 4 -- OVERSTORT
		WHEN lower(strengtype) LIKE '%zinker%'      OR lower(strengtype) LIKE '%Duiker%'	                                                   THEN 3 -- TRANSPORT
   
        WHEN lower(stelseltyp) LIKE '%gemengd%'                                                                                                THEN 0-- GEMENGD
        WHEN lower(stelseltyp) LIKE '%rwa%'         OR lower(stelseltyp) LIKE '%hwa%'                   OR lower(stelseltyp) LIKE '%drainage%' THEN 1	-- RWA
		WHEN lower(stelseltyp) LIKE '%dwa%'            	                                                                                       THEN 2	-- DWA
        
        --std_stelse--
		WHEN lower(std_stelse) LIKE '%gemengd%'	                                                                                               THEN 0	-- GEMENGD
		WHEN lower(std_stelse) LIKE '%hemel%' OR lower(std_stelse) = 'hemelwater gs'	                                                   THEN 1	-- RWA
		WHEN lower(std_stelse) LIKE '%vuil%'	                                                                                           THEN 2	-- DWA
        
        --strengtype rwa,dwa,gemengd--
        WHEN lower(strengtype) LIKE '%gemengd%'                                                                                                THEN 0	-- GEMENGD
        WHEN lower(strengtype) LIKE '%rwa%'                                                                                                    THEN 1	-- RWA
        WHEN lower(strengtype) LIKE '%dwa%'                                                                                                    THEN 2	-- DWA
		
        ELSE NULL -- overig
   
	END AS sewerage_type,
    
	bob_begin_ AS invert_level_start_point,
	bob_eind_a AS invert_level_end_point,
	1 as cross_section_definition_id,
	CASE
		WHEN a.materiaa01 ILIKE '%beton%' OR a.std_materi ILIKE '%beton%' THEN 0
		WHEN a.materiaa01 ILIKE '%pvc%' OR a.std_materi ILIKE '%pvc%' THEN 1
		WHEN a.materiaa01 ILIKE '%gres%' OR a.std_materi ILIKE '%gres%' THEN 2
		WHEN a.materiaa01 ILIKE '%HPE%' OR a.std_materi ILIKE '%HPE%' OR a.materiaa01 LIKE '%PE%' OR a.std_materi LIKE '%PE%' THEN 5
		WHEN a.materiaa01 ILIKE '%staal%' OR a.std_materi ILIKE '%staal%' THEN 8	--        	    -
		WHEN a.materiaa01 ILIKE '%relyn%' OR a.std_materi ILIKE '%relyn%' THEN 98 --relyned
		WHEN a.materiaa01 ILIKE '%overig%' OR a.std_materi ILIKE '%overig%' THEN 99 --overig
		ELSE NULL
	END AS material,
	a.lengte	AS original_length,
	2 AS zoom_category,
	s.id AS connection_node_start_id,
	e.id AS connection_node_end_id
	FROM src.leidingen_gbi a
	LEFT JOIN src.putten_gbi s ON beginput_i = s.object_gui
	LEFT JOIN src.putten_gbi e ON eindput_id = e.object_gui
    where a.aanlegjaar != 9999 or lower(strengtype) NOT LIKE 'volgeschuimd' or lower(strengtype) NOT LIKE 'buiten gebruik';


-----------------------------------------------------------
-------- Stap 4: cross-sections voor pipe toevoegen -------
-----------------------------------------------------------
SELECT buistype, std_buisty, buisvorm, breedte, hoogte, diameter, count(*)
FROM src.leidingen_gbi
GROUP BY  buistype, std_buisty, buisvorm, breedte, hoogte, diameter
ORDER BY buistype, std_buisty, buisvorm, breedte, hoogte, diameter
LIMIT 20;

SELECT CASE diameter WHEN 0 then NULL::numeric END as diamter, * FROM src.leidingen_gbi LIMIT 20;
---- ZET IN 1 KEER ALLES OM NAAR LOCATION EN DEFINITION
-- set sequence maximum id
--UPDATE v2_pipe SET cross_section_definition_id = 1;
delete from v2_cross_section_definition where id > 1;
select setval('v2_cross_section_definition_id_seq',1);
--insert cross_section_definition and add definition_id in v2_cross_section_location
with gather_data as (
	SELECT DISTINCT buistype, 
	--COALESCE(
		(string_to_array(buisvorm,' '))[1],
		NULL--(string_to_array(buistype,' '))[1])
		as vorm,
	COALESCE(
		CASE breedte WHEN 0 then NULL::numeric ELSE breedte/1000.0 END,
		CASE diameter WHEN 0 then NULL::numeric ELSE diameter/1000.0 END
		--round((string_to_array((string_to_array(regexp_replace(regexp_replace(buistype,'x', '/'),'.*[a-zA-Z]',''),' '))[2],'/'))[1]::numeric/1000.0,3)) 
	) as width,
	COALESCE(
		CASE hoogte WHEN 0 then NULL::numeric ELSE hoogte/1000.0 END, 
		CASE diameter WHEN 0 then NULL::numeric ELSE diameter/1000.0 END
		-- round((string_to_array((string_to_array(regexp_replace(regexp_replace(buistype,'x', '/'),'.*[a-zA-Z]',''),' '))[2],'/'))[2]::numeric/1000.0,3)) 
	) as height
	FROM src.leidingen_gbi
	WHERE buistype IS NOT NULL
	ORDER BY buistype
),
create_definitions as (
	INSERT INTO v2_cross_section_definition
	SELECT nextval('v2_cross_section_definition_id_seq') as id,
	CASE WHEN vorm ilike '%rond%' THEN 2
		WHEN vorm ilike '%ei%' then 3
		when vorm ilike '%vierkant%' THEN 5
		when vorm ilike '%rh%' THEN 5
		ELSE NULL
	END as shape,
	width::double precision,
	height::double precision,
	buistype as code
	FROM gather_data
	ORDER BY id
	RETURNING *
)
UPDATE v2_pipe
SET cross_section_definition_id = b.id
FROM create_definitions b, src.leidingen_gbi c
WHERE v2_pipe.id = c.id AND b.code = c.buistype
