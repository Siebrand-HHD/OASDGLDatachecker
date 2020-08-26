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
-------- Stap 3: Leidingen invoeren -------
-------------------------------------------------

-- CHECK OF AL JOUW materialen, strengtype etc voorkomen!!
DELETE FROM v2_pipe;
INSERT INTO v2_pipe(
            id, display_name, code, sewerage_type,
            invert_level_start_point, invert_level_end_point, cross_section_definition_id,
            material, zoom_category, connection_node_start_id, connection_node_end_id)
SELECT
	a.id 		AS id,
    COALESCE(strengcode,'leeg') as display_name,
	COALESCE(s.putcode,'0') || '_' || COALESCE(e.putcode,'0')	AS code,
	CASE
		--We achten stelseltyp het belangrijkste, alleen als dit geen uitsluitsel geeft over het sewerage_type zullen andere kolommen worden gebruikt: std_stelse 
        --strengtype kunstwerken--
        WHEN lower(std_streng) LIKE '%bergbezink%'		                                     THEN 7 -- BERGBEZINKVOORZIENING
		WHEN lower(std_streng) LIKE '%zinker%' OR lower(std_streng) LIKE '%duiker%'     	 THEN 3 -- TRANSPORT

        --std_stelse--
		WHEN lower(std_stelse) LIKE '%gemengd%'	                                             THEN 0	-- GEMENGD
		WHEN lower(std_stelse) LIKE '%hemel%'	                                             THEN 1	-- RWA
		WHEN lower(std_stelse) LIKE '%vuil%'	                                             THEN 2	-- DWA

		WHEN lower(std_stelse) LIKE '%overig%'                                               THEN 10	-- OVERIG
		WHEN lower(std_stelse) IS NOT NULL                                                   THEN 11	-- OVERIG

        ELSE NULL 																						-- onbekend
   
	END AS sewerage_type,
    
	bob_begin_ AS invert_level_start_point,
	bob_eind_a AS invert_level_end_point,
	NULL as cross_section_definition_id,
	CASE
		WHEN lower(a.std_materi) IS NULL THEN NULL
		WHEN lower(a.std_materi) LIKE '%beton%' THEN 0
		WHEN lower(a.std_materi) LIKE '%pvc%' THEN 1
		WHEN lower(a.std_materi) LIKE '%gres%' THEN 2
		WHEN lower(a.std_materi) LIKE '%gietijzer%' THEN 3
		WHEN lower(a.std_materi) LIKE '%metselwerk%' THEN 4
		WHEN lower(a.std_materi) LIKE '%PE%' OR lower(a.std_materi) LIKE '%poly%' THEN 5
		WHEN lower(a.std_materi) LIKE '%plaatijzer%' THEN 7
		WHEN lower(a.std_materi) LIKE '%staal%' THEN 8        	    
		WHEN lower(a.std_materi) LIKE '%overig%' THEN 9 --overig
		ELSE 99
	END AS material,
	2 AS zoom_category,
	s.id AS connection_node_start_id,
	e.id AS connection_node_end_id
	FROM src.leidingen_gbi a
	LEFT JOIN src.putten_gbi s ON beginput_i = s.object_gui
	LEFT JOIN src.putten_gbi e ON eindput_id = e.object_gui;
    --where a.aanlegjaar != 9999 or lower(strengtype) NOT LIKE 'volgeschuimd' or lower(strengtype) NOT LIKE 'buiten gebruik';


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
delete from v2_cross_section_definition;
select setval('v2_cross_section_definition_id_seq',1);
--insert cross_section_definition and add definition_id in v2_cross_section_location
with gather_data as (
	SELECT DISTINCT buistype, 
		buisvorm,
	CASE WHEN buisvorm ilike '%rond%' THEN 2
		WHEN buisvorm ilike '%ei%' then 3
		when buisvorm ilike '%vierkant%' THEN 5
		when buisvorm ilike '%rh%' THEN 5
		ELSE NULL
	END as shape,
	(CASE
		WHEN (string_to_array(buisvorm,' '))[1] LIKE '%rond%' 
			THEN COALESCE(
				CASE diameter WHEN 0 then NULL::numeric ELSE diameter/1000.0 END,
				CASE breedte WHEN 0 then NULL::numeric ELSE breedte/1000.0 END
			)
		ELSE COALESCE(
				CASE breedte WHEN 0 then NULL::numeric ELSE breedte/1000.0 END,
				CASE diameter WHEN 0 then NULL::numeric ELSE diameter/1000.0 END
			)
	END) AS width,
	COALESCE(
		CASE hoogte WHEN 0 then NULL::numeric ELSE hoogte/1000.0 END, 
		CASE diameter WHEN 0 then NULL::numeric ELSE diameter/1000.0 END

	) as height
	FROM src.leidingen_gbi
	ORDER BY buistype
),
create_definitions as (
	INSERT INTO v2_cross_section_definition
	SELECT nextval('v2_cross_section_definition_id_seq') as id,
	shape,
	CASE WHEN shape = 5 OR shape = 6 
	THEN width || ' ' || width || ' 0'
	ELSE width::text
	END as width,
	CASE WHEN shape = 5 OR shape = 6 
	THEN  '0 ' || height || ' ' || height
	ELSE height::text
	END as height,
	COALESCE(buistype,'leeg') as code
	FROM gather_data
	ORDER BY id
	RETURNING *
)
UPDATE v2_pipe
SET cross_section_definition_id = b.id
FROM create_definitions b, src.leidingen_gbi c
WHERE v2_pipe.id = c.id AND b.code = c.buistype
