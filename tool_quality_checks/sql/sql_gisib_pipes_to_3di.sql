-------------------------------------------------------------------------------------------
--- Gisib TO 3Di (currently manholes and pipes only)
--- Input: Export of Gisib (vrijv_leiding.shp and rioolput.shp)
--- Output: 3Di model in work_db
-------------------------------------------------------------------------------------------

-------------------------------------------------
------ Stap 0: Data inladen ---------------------
-------------------------------------------------
/* Used in other scripts
-- import Gisib files with ogr2ogr
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

ALTER TABLE src.leidingen_gisib
	ADD COLUMN IF NOT EXISTS soort_afva VARCHAR(255);
	
ALTER TABLE src.leidingen_gisib
	ADD COLUMN IF NOT EXISTS materiaal VARCHAR(255);
	
ALTER TABLE src.leidingen_gisib
	ADD COLUMN IF NOT EXISTS buismateri VARCHAR(255);

ALTER TABLE src.leidingen_gisib
	ADD COLUMN IF NOT EXISTS breedte_le INTEGER;
/*
ALTER TABLE src.leidingen_gisib
	ALTER COLUMN id TYPE INTEGER;
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
	a.id::integer AS id,
    COALESCE(a.naam_of_nu,'leeg') as display_name,
	COALESCE(s.naam_of_nu,'0') || '_' || COALESCE(e.naam_of_nu,'0')	AS code,
	-- GISIB gebruikers: Midden-Delfland gebruikt de kolom 'soort_afva' en Westland de kolom 'gebruik_af'
	CASE 
		WHEN a.soort_afva IS NULL THEN
			CASE
				WHEN lower(a.type_afwat) LIKE '%bergbezink%'										THEN 7 -- BERGBEZINKVOORZIENING
				WHEN lower(a.type_afwat) LIKE '%zinker%' 	OR lower(a.type_afwat) LIKE '%duiker%'	THEN 3 -- TRANSPORT

				WHEN lower(a.gebruik_af) LIKE '%combi%'												THEN 0	-- GEMENGD
				WHEN lower(a.gebruik_af) LIKE '%hemel%'												THEN 1	-- RWA
				WHEN lower(a.gebruik_af) LIKE '%afval%'												THEN 2	-- DWA

				WHEN lower(a.gebruik_af) LIKE '%overig%'											THEN 10	-- OVERIG
				WHEN lower(a.gebruik_af) IS NOT NULL												THEN 11	-- OVERIG
				ELSE NULL																		-- onbekend
			END
		ELSE
			CASE
				-- Een duiker, zinker of bergbezinkbassin worden eerst
				WHEN lower(a.type_afwat) LIKE '%bergbezink%'										THEN 7 -- BERGBEZINKVOORZIENING
				WHEN lower(a.type_afwat) LIKE '%zinker%' 	OR lower(a.type_afwat) LIKE '%duiker%'	THEN 3 -- TRANSPORT

				WHEN lower(a.soort_afva) LIKE '%gemengd%'											THEN 0	-- GEMENGD
				WHEN lower(a.soort_afva) LIKE '%regen%'		OR lower(a.soort_afva) LIKE '%hemel%'	THEN 1	-- RWA
				WHEN lower(a.soort_afva) LIKE '%vuil%'		OR lower(a.soort_afva) LIKE '%droog%'	THEN 2	-- DWA

				WHEN lower(a.soort_afva) LIKE '%overig%'											THEN 10	-- OVERIG
				WHEN lower(a.soort_afva) IS NOT NULL												THEN 11	-- OVERIG
				ELSE NULL																				-- onbekend
			END
	END AS sewerage_type,
	a.begin_bob AS invert_level_start_point,
	a.eind_bob AS invert_level_end_point,
	NULL as cross_section_definition_id,
	CASE
		WHEN lower(COALESCE(a.buismateri, a.materiaal)) IS NULL THEN NULL
		WHEN lower(COALESCE(a.buismateri, a.materiaal)) LIKE '%beton%' THEN 0
		WHEN lower(COALESCE(a.buismateri, a.materiaal)) LIKE '%pvc%' THEN 1
		WHEN lower(COALESCE(a.buismateri, a.materiaal)) LIKE '%gres%' THEN 2
		WHEN lower(COALESCE(a.buismateri, a.materiaal)) LIKE '%gietijzer%' THEN 3
		WHEN lower(COALESCE(a.buismateri, a.materiaal)) LIKE '%metselwerk%' THEN 4
		WHEN lower(COALESCE(a.buismateri, a.materiaal)) LIKE '%PE%' OR lower(COALESCE(a.buismateri, a.materiaal)) LIKE '%poly%' THEN 5
		WHEN lower(COALESCE(a.buismateri, a.materiaal)) LIKE '%plaatijzer%' THEN 7
		WHEN lower(COALESCE(a.buismateri, a.materiaal)) LIKE '%staal%' THEN 8
		WHEN lower(COALESCE(a.buismateri, a.materiaal)) LIKE '%overig%' THEN 9 --overig
		ELSE 99
	END AS material,
	2 AS zoom_category,
	s.id::integer AS connection_node_start_id,
	e.id::integer AS connection_node_end_id
	FROM src.leidingen_gisib a
	LEFT JOIN src.putten_gisib s ON a.begin_knoo::integer = s.id::integer
	LEFT JOIN src.putten_gisib e ON a.eind_knoop::integer = e.id::integer;
    --where a.aanlegjaar != 9999 or lower(strengtype) NOT LIKE 'volgeschuimd' or lower(strengtype) NOT LIKE 'buiten gebruik';


-----------------------------------------------------------
-------- Stap 4: cross-sections voor pipe toevoegen -------
-----------------------------------------------------------
SELECT afmeting_l, vorm, breedte_le, hoogte_lei, diameter, count(*)
FROM src.leidingen_gisib
GROUP BY afmeting_l, vorm, breedte_le, hoogte_lei, diameter
ORDER BY afmeting_l, vorm, breedte_le, hoogte_lei, diameter
LIMIT 20;

SELECT CASE diameter WHEN 0 then NULL::numeric END as diamter, * FROM src.leidingen_gisib LIMIT 20;
---- ZET IN 1 KEER ALLES OM NAAR LOCATION EN DEFINITION
-- set sequence maximum id
delete from v2_cross_section_definition;
select setval('v2_cross_section_definition_id_seq',1);
--insert cross_section_definition and add definition_id in v2_cross_section_location
with gather_data as (
	SELECT DISTINCT afmeting_l, 
		vorm,
	CASE WHEN vorm ilike '%cirkel%' THEN 2
		WHEN vorm ilike '%ei%' then 3
		when vorm ilike '%vierkant%' THEN 5
		when vorm ilike '%rh%' THEN 5
		ELSE NULL
	END as shape,
	(CASE
		WHEN (string_to_array(vorm,' '))[1] LIKE '%cirkel%' 
			THEN COALESCE(
				CASE diameter WHEN 0 then NULL::numeric ELSE diameter/1000.0 END,
				CASE breedte_le WHEN 0 then NULL::numeric ELSE breedte_le/1000.0 END
			)
		ELSE COALESCE(
				CASE breedte_le WHEN 0 then NULL::numeric ELSE breedte_le/1000.0 END,
				CASE diameter WHEN 0 then NULL::numeric ELSE diameter/1000.0 END
			)
	END) AS width,
	COALESCE(
		CASE hoogte_lei WHEN 0 then NULL::numeric ELSE hoogte_lei/1000.0 END, 
		CASE diameter WHEN 0 then NULL::numeric ELSE diameter/1000.0 END

	) as height
	FROM src.leidingen_gisib
	ORDER BY afmeting_l
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
	COALESCE(afmeting_l,'leeg') as code
	FROM gather_data
	ORDER BY id
	RETURNING *
)
UPDATE v2_pipe
SET cross_section_definition_id = b.id
FROM create_definitions b, src.leidingen_gisib c
WHERE v2_pipe.id = c.id AND b.code = c.afmeting_l
