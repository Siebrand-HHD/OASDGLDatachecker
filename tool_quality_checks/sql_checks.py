# -*- coding: utf-8 -*-

sql_checks = {
    "sql_completeness_manhole": """
------------------- Putten -------------------------
----------------------------------------------------
SELECT count(*) FROM v2_manhole;
-- Check extreme values to potentially edit queries below (e.g. surface_level = -99)
DROP TABLE IF EXISTS chk.put_extreme_values;
CREATE TABLE chk.put_extreme_values AS
SELECT  max(surface_level) as max_surface_level,
	min(surface_level) as min_surface_level,
	max(bottom_level) as max_bottom_level,
	min(bottom_level) as min_bottom_level
FROM v2_manhole;
-- Maaiveldhoogte aanwezig
DROP TABLE IF EXISTS chk.put_surface_level;
CREATE TABLE chk.put_surface_level AS
SELECT * FROM v2_manhole_view WHERE manh_surface_level IS NULL
				OR manh_surface_level < {min_levels}
				or manh_surface_level > {max_levels};

DROP TABLE IF EXISTS chk.put_surface_level_0;
CREATE TABLE chk.put_surface_level_0 AS
SELECT * FROM v2_manhole_view WHERE manh_surface_level = 0;

-- BOK aanwezig
DROP TABLE IF EXISTS chk.put_bottom_level;
CREATE TABLE chk.put_bottom_level AS
SELECT * 
FROM v2_manhole_view 
WHERE manh_bottom_level IS NULL
	OR manh_bottom_level < {min_levels}
	or manh_bottom_level > {max_levels}
ORDER BY manh_bottom_level;
DROP TABLE IF EXISTS chk.put_bottom_level_0;
CREATE TABLE chk.put_bottom_level_0 AS
SELECT * FROM v2_manhole_view WHERE manh_bottom_level = 0;
-- Vorm aanwezig
DROP TABLE IF EXISTS chk.put_shape_count;
CREATE TABLE chk.put_shape_count AS
SELECT shape, count(*) FROM v2_manhole group by shape;
DROP TABLE IF EXISTS chk.put_shape;
CREATE TABLE chk.put_shape AS
SELECT *, 'shape missing'::text as chk_message FROM v2_manhole_view WHERE manh_shape IS NULL;
-- Afmetingen putten
DROP TABLE IF EXISTS chk.put_dimensions_0;
CREATE TABLE chk.put_dimensions_0 AS
SELECT * FROM v2_manhole_view WHERE manh_width = 0 OR manh_length = 0;

-- ronde putten zonder afmeting
DROP TABLE IF EXISTS chk.put_dimensions;
CREATE TABLE chk.put_dimensions AS
SELECT *, 'rnd width missing'::text as chk_message FROM v2_manhole_view WHERE manh_width IS NULL AND manh_shape = 'rnd'
UNIOn ALL
SELECT *, 'rnd width is not length' as chk_message FROM v2_manhole_view WHERE manh_width != manh_length AND manh_shape = 'rnd'
UNIOn ALL
-- vierkante putten zonder afmeting;
SELECT *, 'sqr width missing' as chk_message FROM v2_manhole_view WHERE (manh_width IS NULL) AND manh_shape = 'sqr'
UNIOn ALL
SELECT *, 'sqr width is not length' as chk_message FROM v2_manhole_view WHERE manh_width != manh_length AND manh_shape = 'sqr'
UNIOn ALL
-- rechthoekige putten zonder afmeting
SELECT *, 'rect width or length missing' as chk_message FROM v2_manhole_view WHERE (manh_width IS NULL OR manh_length IS NULL) AND manh_shape = 'rect';

-------------------- Uitlaten ----------------------
----------------------------------------------------
DROP TABLE IF EXISTS chk.number_of_boundaries;
CREATE TABLE chk.number_of_boundaries AS
SELECT count(*), 'boundary_tabel' as chk_message FROM v2_1d_boundary_conditions
UNION ALL
SELECT count(*), 'manhole_tabel' as chk_message FROM v2_manhole WHERE manhole_indicator = 1;
-- Randvoorwaarde aanwezig
DROP TABLE IF EXISTS chk.randvoorwaarden_timeseries;
CREATE TABLE chk.randvoorwaarden_timeseries AS
SELECT * FROM v2_1d_boundary_conditions_view WHERE timeseries IS NULL ORDER BY boundary_type;

-- Randvoorwaarde aanwezig
DROP TABLE IF EXISTS chk.randvoorwaarden_type;
CREATE TABLE chk.randvoorwaarden_type AS
SELECT * FROM v2_1d_boundary_conditions_view WHERE boundary_type IS NULL OR boundary_type = 2 OR boundary_type > 3;
""",
    "sql_completeness_pipe": """
----------------- Leidingen ------------------------
----------------------------------------------------

SELECT count(*) FROM v2_pipe;

-- Check begin- en eindpunt aanwezig
DROP TABLE IF EXISTS chk.leiding_connection_nodes;
CREATE TABLE chk.leiding_connection_nodes AS
SELECT * FROM v2_pipe WHERE connection_node_start_id IS NULL OR connection_node_end_id IS NULL;

-- Rioleringstype aanwezig
DROP TABLE IF EXISTS chk.leiding_sewerage_type_count;
CREATE TABLE chk.leiding_sewerage_type_count AS
SELECT pipe_sewerage_type, count(*) FROM v2_pipe_view group by pipe_sewerage_type ORDER BY pipe_sewerage_type;

DROP TABLE IF EXISTS chk.leiding_sewerage_type;
CREATE TABLE chk.leiding_sewerage_type AS
SELECT * FROM v2_pipe_view WHERE pipe_sewerage_type IS NULL;

-- Materiaal aanwezig
DROP TABLE IF EXISTS chk.leiding_material_count;
CREATE TABLE chk.leiding_material_count AS
SELECT material, count(*) FROM v2_pipe group by material ORDER BY material;
DROP TABLE IF EXISTS chk.leiding_material;
CREATE TABLE chk.leiding_material AS
SELECT * FROM v2_pipe_view WHERE pipe_material IS NULL;

-- Check extreme values to potentially edit queries below (e.g. surface_level = -99)
DROP TABLE IF EXISTS chk.leiding_extreme_values;
CREATE TABLE chk.leiding_extreme_values AS
SELECT  max(invert_level_start_point) as max_start_level,
	min(invert_level_end_point) as min_start_level,
	max(invert_level_start_point) as max_end_level,
	min(invert_level_end_point) as min_end_level
FROM v2_pipe;

 -- BOB's aanwezig
DROP TABLE IF EXISTS chk.leiding_bobs;
CREATE TABLE chk.leiding_bobs AS
SELECT *,
		(	CASE WHEN def_shape = 2 THEN def_width::double precision
			WHEN def_shape = 3 THEN def_height::double precision
			WHEN def_shape > 4 THEN array_greatest(string_to_array(def_height,' '))::double precision
			ELSE 0
			END
		) as profiel_hoogte
FROM v2_pipe_view WHERE pipe_invert_level_start_point IS NULL
				OR pipe_invert_level_start_point < {min_levels}
				or pipe_invert_level_start_point > {max_levels}
				OR pipe_invert_level_end_point IS NULL
				OR pipe_invert_level_end_point < {min_levels}
				or pipe_invert_level_end_point > {max_levels};
DROP TABLE IF EXISTS chk.leiding_bobs_0;
CREATE TABLE chk.leiding_bobs_0 AS
SELECT * FROM v2_pipe_view WHERE pipe_invert_level_start_point = 0 OR pipe_invert_level_end_point = 0;

-- Cross_section_definition aanwezig
DROP TABLE IF EXISTS chk.leiding_missing_xsec;
CREATE TABLE chk.leiding_missing_xsec AS
SELECT * FROM chk.v2_pipe_view_left_join WHERE pipe_cross_section_definition_id is NULL;

-- check if pipe is closed rectangle
DROP TABLE IF EXISTS chk.leiding_check_closed_rectangle;
CREATE TABLE chk.leiding_check_closed_rectangle AS
SELECT * FROM v2_pipe_view WHERE def_shape = 1;
""",
    "sql_completeness_pumpstation": """
------------------- Gemalen ------------------------
----------------------------------------------------
-- Aantal pompen
DROP TABLE IF EXISTS chk.number_pumps;
CREATE TABLE chk.number_pumps AS
SELECT count(*), 'alle gemaalkelders' as chk_message FROM v2_pumpstation
-- Aantal gemaalkelders
UNION ALL
SELECT count(DISTINCT connection_node_start_id), 'alle gemaalkelders uit pomptabel' FROM v2_pumpstation
-- Aantal gemaalkelders
UNION ALL
SELECT count(*), 'alle gemaalkelders uit manholetabel' FROM v2_manhole WHERE manhole_indicator = 2;
-- Check begin- en eindpunt aanwezig
DROP TABLE IF EXISTS chk.pomp_connection_node;
CREATE TABLE chk.pomp_connection_node AS
SELECT * FROM v2_pumpstation WHERE connection_node_start_id IS NULL;

-- Aan- en afslagpeil bekend
DROP TABLE IF EXISTS chk.pomp_extreme_waarden;
CREATE TABLE chk.pomp_extreme_waarden AS
SELECT  max(start_level) as max_start_level,
	min(start_level) as min_start_level,
	max(lower_stop_level) as max_lower_stop_level,
	min(lower_stop_level) as min_lower_stop_level,
	max(upper_stop_level) as max_upper_stop_level,
	min(upper_stop_level) as min_upper_stop_level
FROM v2_pumpstation;

DROP TABLE IF EXISTS chk.pomp_levels;
CREATE TABLE chk.pomp_levels AS
SELECT * FROM v2_pumpstation_point_view WHERE start_level IS NULL
				OR start_level < {min_levels}
				or start_level > {max_levels}
				OR lower_stop_level IS NULL
				OR lower_stop_level < {min_levels}
				or lower_stop_level > {max_levels}
				OR upper_stop_level < {min_levels}
				or upper_stop_level > {max_levels};
DROP TABLE IF EXISTS chk.pomp_levels_0;
CREATE TABLE chk.pomp_levels_0 AS
SELECT * FROM v2_pumpstation_point_view WHERE start_level = 0
					OR lower_stop_level = 0
					OR upper_stop_level = 0;

-- capaciteit bekend
DROP TABLE IF EXISTS chk.pomp_capacity;
CREATE TABLE chk.pomp_capacity AS
SELECT * FROM v2_pumpstation_point_view WHERE capacity IS NULL;
DROP TABLE IF EXISTS chk.pomp_capacity_0;
CREATE TABLE chk.pomp_capacity_0 AS
SELECT * FROM v2_pumpstation_point_view WHERE capacity = 0;
""",
    "sql_completeness_weir": """
----------------- Overstorten ----------------------
----------------------------------------------------
SELECT count(*) FROM v2_weir;
DROP TABLE IF EXISTS chk.overstort_extreme_waarden;
CREATE TABLE chk.overstort_extreme_waarden AS
SELECT  max(crest_level) as max_drempelhoogte,
	min(crest_level) as min_drempelhoogte
FROM v2_weir;
-- Compartimentering aanwezig
DROP TABLE IF EXISTS chk.overstort_connection_nodes;
CREATE TABLE chk.overstort_connection_nodes AS
SELECT * FROM v2_weir WHERE connection_node_start_id IS NULL or connection_node_end_id IS NULL;

-- Drempelhoogte aanwezig
DROP TABLE IF EXISTS chk.overstort_crest_level;
CREATE TABLE chk.overstort_crest_level AS
SELECT * FROM v2_weir_view WHERE weir_crest_level IS NULL
				OR weir_crest_level < {min_levels}
				or weir_crest_level > {max_levels};
DROP TABLE IF EXISTS chk.overstort_crest_level_0;
CREATE TABLE chk.overstort_crest_level_0 AS
SELECT * FROM v2_weir_view WHERE weir_crest_level = 0;

-- Discharge coefficient aanwezig
DROP TABLE IF EXISTS chk.overstort_discharge_coefficient;
CREATE TABLE chk.overstort_discharge_coefficient AS
SELECT * FROM v2_weir_view WHERE weir_discharge_coefficient_positive IS NULL
				OR weir_discharge_coefficient_negative IS NULL;
DROP TABLE IF EXISTS chk.overstort_closed;
CREATE TABLE chk.overstort_closed AS
SELECT * FROM v2_weir_view WHERE weir_discharge_coefficient_positive = 0
				OR weir_discharge_coefficient_negative = 0;

-- Drempelbreedte aanwezig
DROP TABLE IF EXISTS chk.overstort_missing_xsec;
CREATE TABLE chk.overstort_missing_xsec AS
SELECT * FROM chk.v2_weir_view_left_join WHERE weir_cross_section_definition_id IS NULL;
""",
    "sql_completeness_orifice": """
------------------- Doorlaten ----------------------
----------------------------------------------------
SELECT count(*) FROM v2_orifice; -- 0
DROP TABLE IF EXISTS chk.doorlaat_extreme_waarden;
CREATE TABLE chk.doorlaat_extreme_waarden AS
SELECT  max(crest_level) as max_drempelhoogte,
	min(crest_level) as min_drempelhoogte
FROM v2_orifice;
-- Compartimentering aanwezig
DROP TABLE IF EXISTS chk.doorlaat_connection_nodes;
CREATE TABLE chk.doorlaat_connection_nodes AS
SELECT * FROM v2_orifice WHERE connection_node_start_id IS NULL or connection_node_end_id IS NULL;

-- Openingshoogte aanwezig
DROP TABLE IF EXISTS chk.doorlaat_crest_level;
CREATE TABLE chk.doorlaat_crest_level AS
SELECT * FROM v2_orifice_view WHERE orf_crest_level IS NULL
				OR orf_crest_level < {min_levels}
				or orf_crest_level > {max_levels};
DROP TABLE IF EXISTS chk.doorlaat_crest_level_0;
CREATE TABLE chk.doorlaat_crest_level_0 AS
SELECT * FROM v2_orifice_view WHERE orf_crest_level = 0;

-- Discharge coefficient aanwezig
DROP TABLE IF EXISTS chk.doorlaat_discharge_coefficient;
CREATE TABLE chk.doorlaat_discharge_coefficient AS
SELECT * FROM v2_orifice_view WHERE orf_discharge_coefficient_positive IS NULL
				OR orf_discharge_coefficient_negative IS NULL;
DROP TABLE IF EXISTS chk.doorlaat_closed;
CREATE TABLE chk.doorlaat_closed AS
SELECT * FROM v2_orifice_view WHERE orf_discharge_coefficient_positive = 0
				OR orf_discharge_coefficient_negative = 0;

-- Drempelbreedte aanwezig
DROP TABLE IF EXISTS chk.doorlaat_missing_xsec;
CREATE TABLE chk.doorlaat_missing_xsec AS
SELECT * FROM chk.v2_orifice_view_left_join WHERE orf_cross_section_definition_id IS NULL;
""",
    "sql_completeness_cross_section_definition": """
----------------- Dwarsdoorsnedes ------------------------
----------------------------------------------------------
DROP TABLE IF EXISTS chk.profiel_extreme_waarden;
CREATE TABLE chk.profiel_extreme_waarden AS
with get_width AS (
	SELECT width::float as greatest_width, height::float as greatest_height, *
	FROM v2_cross_section_definition_rio_view
	WHERE shape < 5
	UNION ALL
	SELECT array_greatest(string_to_array(width,' '))::float as greatest_width, array_greatest(string_to_array(height,' '))::float as greatest_height,*
	FROM v2_cross_section_definition_rio_view
	WHERE shape > 4
)
SELECT structure_type, min(greatest_width) as min_width, max(greatest_width) as max_width, min(greatest_height) as min_height, max(greatest_height) as max_height
FROM get_width
GROUP BY structure_type;

-- Width en shape beschikbaar
DROP TABLE IF EXISTS chk.profiel_shape;
CREATE TABLE chk.profiel_shape AS
SELECT * FROM v2_cross_section_definition_rio_view WHERE shape IS NULL;
DROP TABLE IF EXISTS chk.profiel_width;
CREATE TABLE chk.profiel_width AS
SELECT * FROM v2_cross_section_definition_rio_view WHERE width IS NULL;
-- check for 0 values
DROP TABLE IF EXISTS chk.profiel_width_0;
CREATE TABLE chk.profiel_width_0 AS
SELECT * FROM v2_cross_section_definition_rio_view WHERE width::double precision = 0 AND shape < 5;
DROP TABLE IF EXISTS chk.profiel_height_0;
CREATE TABLE chk.profiel_height_0 AS
SELECT * FROM v2_cross_section_definition_rio_view WHERE height:: double precision = 0 AND shape < 5;

-- check circle
DROP TABLE IF EXISTS chk.profiel_dimensions;
CREATE TABLE chk.profiel_dimensions AS
SELECT *, 'circle shape is not correct' as chk_message FROM v2_cross_section_definition_rio_view WHERE width != height AND height IS NOT NULL AND shape = 2
UNION ALL
-- check egg shape dimensions
SELECT *, 'egg shape is not correct' as chk_message FROM v2_cross_section_definition_rio_view WHERE round(1.5*width::numeric,4) != round(height::numeric,4) AND shape = 3
UNION ALL
-- check tabulated
SELECT *, 'tabulated height is null' as chk_message FROM v2_cross_section_definition_rio_view WHERE height IS NULL AND shape > 4
UNION ALL
SELECT *, 'tabulated is missing multiple params' as chk_message FROM v2_cross_section_definition_rio_view WHERE (NOT width LIKE '% %' OR NOT height LIKE '% %') AND shape > 4;
""",
    # ---------------------------------------------------
    # ----------- Kwaliteitchecks Riolering -------------
    # ---------------------------------------------------
    "sql_quality_manhole": """
------------------- Putten -------------------------
----------------------------------------------------

-- Check putten buiten de dem
DROP TABLE IF EXISTS chk.put_buiten_dem;
CREATE TABLE chk.put_buiten_dem AS
SELECT *
FROM src.manhole_maaiveld
WHERE maaiveld IS NULL or maaiveld = -9999;

-- AHN2 Check - hoogte verschil
-- betrouwbaarheid putten tov AHN2
DROP TABLE IF EXISTS chk.put_maaiveld_check;
CREATE TABLE chk.put_maaiveld_check AS
WITH calc_hoogte_verschil AS (
	SELECT round((maaiveld - surface_level)::numeric,2) as hoogte_verschil, round(surface_level::numeric,2) as model_maaiveld, maaiveld as dem_maaiveld, a.*
	FROM v2_manhole b JOIN src.manhole_maaiveld a ON a.{id_field} = b.id
	WHERE maaiveld != -9999
)
SELECT *
FROM calc_hoogte_verschil
WHERE abs(hoogte_verschil) > {hoogte_verschil};

-- Maaiveldhoogte > bok
DROP TABLE IF EXISTS chk.put_maaiveld_vs_bok;
CREATE TABLE chk.put_maaiveld_vs_bok AS
SELECT (manh_surface_level - manh_bottom_level) as putdiepte, *
FROM v2_manhole_view
WHERE manh_surface_level < manh_bottom_level + {min_dekking}
ORDER BY (manh_surface_level - manh_bottom_level);

-- BOK > laagste bob
-- first join the start bob's
DROP TABLE IF EXISTS chk.put_bob_vs_bok;
CREATE TABLE chk.put_bob_vs_bok AS
with bob_invert_levels AS(
SELECT sm.manh_id as sm_id, sm.manh_surface_level, sm.manh_bottom_level, 
		CASE WHEN sm.manh_connection_node_id = pv.connection_node_start_id::integer THEN pv.invert_level_start_point
			 WHEN sm.manh_connection_node_id = pv.connection_node_end_id::integer THEN pv.invert_level_end_point
		ELSE NULL END 
	as bob_level, 
	pv.id as pv_id, the_geom
FROM v2_manhole_view as sm 
JOIN v2_pipe as pv ON sm.manh_connection_node_id = pv.connection_node_start_id::integer OR sm.manh_connection_node_id = pv.connection_node_end_id::integer
ORDER BY sm_id, pv_id
)
-- select the lowest
select distinct on (sm_id) * from bob_invert_levels WHERE  manh_bottom_level > bob_level
ORDER BY sm_id, bob_level ASC;

-- Afmeting buis > grootste aangesloten diameter
-- first join aangesloten diameters
DROP TABLE IF EXISTS chk.put_afm_vs_diam;
CREATE TABLE chk.put_afm_vs_diam AS
with aangesloten_diameters AS(
SELECT sm.manh_id as sm_id,
    greatest(sm.manh_width, sm.manh_length) as grootste_put_afm,
    pv.pipe_id as pv_id,
    sm.the_geom,
    array_greatest(string_to_array(pv.def_width,' '))::float as greatest_width
FROM v2_manhole_view as sm
JOIN v2_pipe_view as pv ON sm.manh_connection_node_id = pv.pipe_connection_node_start_id::integer OR sm.manh_connection_node_id = pv.pipe_connection_node_end_id::integer
ORDER BY sm_id, pv_id
)
-- select the lowest
select distinct on (sm_id) * from aangesloten_diameters WHERE grootste_put_afm < greatest_width + {padding_manhole}
ORDER BY sm_id, greatest_width DESC;

-- Losliggende putten
DROP TABLE IF EXISTS chk.connectieknoop_losliggend;
CREATE TABLE chk.connectieknoop_losliggend AS
SELECT * FROM v2_connection_nodes WHERE
(id NOT IN (select connection_node_start_id from v2_pipe WHERE connection_node_start_id is not NULL)
AND id NOT IN (select connection_node_end_id from v2_pipe WHERE connection_node_end_id  is not NULL)
AND id NOT IN (select connection_node_start_id from v2_weir WHERE connection_node_start_id is not NULL)
AND id NOT IN (select connection_node_end_id from v2_weir WHERE connection_node_end_id is not NULL)
AND id NOT IN (select connection_node_start_id from v2_orifice WHERE connection_node_start_id is not NULL)
AND id NOT IN (select connection_node_end_id from v2_orifice WHERE connection_node_end_id  is not NULL)
AND id NOT IN (select connection_node_start_id from v2_culvert WHERE connection_node_start_id is not NULL)
AND id NOT IN (select connection_node_end_id from v2_culvert WHERE connection_node_end_id  is not NULL)
AND id NOT IN (select connection_node_start_id from v2_channel WHERE connection_node_start_id is not NULL)
AND id NOT IN (select connection_node_end_id from v2_channel WHERE connection_node_end_id  is not NULL));

-- Dubbele putten
DROP TABLE IF EXISTS chk.connectieknoop_dubbel;
CREATE TABLE chk.connectieknoop_dubbel AS
with double_manhole as (
select the_geom, count(*) from v2_connection_nodes
group by the_geom
having count(*) > 1)
select a.* from v2_connection_nodes a, double_manhole b where a.the_geom && b.the_geom;

-- Putten binnen 20 cm van elkaar
drop table if exists chk.connectieknoop_afstand_20cm;
create table chk.connectieknoop_afstand_20cm AS
select DISTINCT ON (cn1.id) cn1.id, cn2.id as other_id, ST_Distance(cn1.the_geom, cn2.the_geom) as afstand, cn1.the_geom
from v2_connection_nodes cn1 JOIN v2_connection_nodes cn2 ON ST_DWithin(cn1.the_geom, cn2.the_geom,0.2)
WHERE cn1.id < cn2.id
ORDER BY cn1.id, ST_Distance(cn1.the_geom, cn2.the_geom);

-- aantal inkomende leidingen
drop table if exists chk.kunstwerken_aantal_inkomend;
create table chk.kunstwerken_aantal_inkomend AS
with connected_nodes as (
select point as geom, count(*) as nr_con, array_to_string(array_agg(distinct line_type), ', ') as line_types
FROM (Select ST_StartPoint(the_geom) as point, 'pipe' as line_type
	FROM v2_pipe_view
	UNION ALL
	Select ST_EndPoint(the_geom) as point, 'pipe' as line_type
	FROM v2_pipe_view
              UNION ALL
              Select ST_StartPoint(the_geom) as point, 'orifice' as line_type
	FROM v2_orifice_view
	UNION ALL
	Select ST_EndPoint(the_geom) as point, 'orifice' as line_type
	FROM v2_orifice_view
              UNION ALL
              Select ST_StartPoint(the_geom) as point, 'weir' as line_type
	FROM v2_weir_view
	UNION ALL
	Select ST_EndPoint(the_geom) as point, 'weir' as line_type
	FROM v2_weir_view
        --      UNION ALL
        --      Select ST_StartPoint(the_geom) as point, 'pumpstation' as line_type
	--FROM v2_pumpstation_view
	--UNION ALL
	--Select ST_EndPoint(the_geom) as point, 'pumpstation' as line_type
	--FROM v2_pumpstation_view
	) as a
GROUP BY point
HAVING count(*) > 1),
nr_connections AS (
SELECT b.nr_con, b.line_types, a.* FROM v2_connection_nodes as a, connected_nodes as b WHERE a.the_geom && b.geom)
select * from nr_connections as n where nr_con > 4 order by nr_con DESC;

-------------------- Uitlaten ----------------------
----------------------------------------------------
-- Uitlaat verbonden aan meedere kunstwerken
Drop table if exists chk.uitlaten_meerdere_connecties;
Create table chk.uitlaten_meerdere_connecties as
with dangling_nodes as (
select point as geom
FROM (Select ST_StartPoint(the_geom) as point
        FROM v2_pipe_view
        UNION ALL
        Select ST_EndPoint(the_geom) as point
        FROM v2_pipe_view
              UNION ALL
              Select ST_StartPoint(the_geom) as point
        FROM v2_orifice_view
        UNION ALL
        Select ST_EndPoint(the_geom) as point
        FROM v2_orifice_view
              UNION ALL
              Select ST_StartPoint(the_geom) as point
        FROM v2_weir_view
        UNION ALL
        Select ST_EndPoint(the_geom) as point
        FROM v2_weir_view
              UNION ALL
              Select ST_StartPoint(the_geom) as point
        FROM v2_pumpstation_view
        UNION ALL
        Select ST_EndPoint(the_geom) as point
        FROM v2_pumpstation_view) as a
GROUP BY point
HAVING count(*) > 1)
SELECT a.* FROM v2_manhole_view as a, dangling_nodes as b WHERE ST_intersects(a.the_geom, b.geom) AND manh_connection_node_id IN (SELECT connection_node_id FROM v2_1d_boundary_conditions);

-- Uitlaat aan eindpunt gemaal
Drop table if exists chk.uitlaat_op_eindpunt_gemaal;
Create table chk.uitlaat_op_eindpunt_gemaal as
SELECT sm.manhole_indicator, sp.*
FROM v2_manhole sm JOIN v2_pumpstation_view sp ON sm.connection_node_id = pump_connection_node_end_id
WHERE sm.manhole_indicator = 1;
""",
    "sql_quality_pipe": """
----------------- Leidingen ------------------------
----------------------------------------------------

-- Zeer korte leidingen (< x m)
DROP TABLE if exists chk.leiding_kort;
create table chk.leiding_kort AS
SELECT ST_Length(the_geom),* FROM v2_pipe_view WHERE ST_Length(the_geom) < {min_length};

-- Zeer lange lange leidingen (> x m)
DROP TABLE if exists chk.leiding_lang;
create table chk.leiding_lang AS
SELECT ST_Length(the_geom),* FROM v2_pipe_view WHERE ST_Length(the_geom) > {max_length};

-- Dubbele leidingen
drop table if exists chk.kunstwerken_dubbel;
create table chk.kunstwerken_dubbel as
select count(*) as number_line_types, string_agg(line_type::text, ', ' ORDER BY line_type) as line_types, string_agg(display_name::text, ', ' ORDER BY line_type) as display_names, string_agg(line_id::text, ', ' ORDER BY line_type) as line_ids, the_geom  from
        (select 'pipe' as line_type,  pipe_id as line_id, pipe_display_name as display_name, the_geom from v2_pipe_view
        union all
        select 'weir' as line_type, weir_id, weir_display_name, the_geom from v2_weir_view
        union all
        select 'pump' as line_type, pump_id, pump_display_name, the_geom from v2_pumpstation_view
        union all
        select 'orifice' as line_type, orf_id, orf_display_name, the_geom from v2_orifice_view) as a
group by the_geom
having count(*) > 1;

-- Verbindingen tussen Gemengd/RWA/DWA
DROP table if exists chk.leiding_verkeerde_types_verbonden;
CREATE TABLE chk.leiding_verkeerde_types_verbonden AS
with nodes as (
select point as geom, pipe_sewerage_type
FROM (Select ST_StartPoint(the_geom) as point, pipe_sewerage_type
        FROM v2_pipe_view
        UNION ALL
        Select ST_EndPoint(the_geom) as point, pipe_sewerage_type
        FROM v2_pipe_view) as a
GROUP BY point, pipe_sewerage_type
),
count_nodes_pipe_typologies as (
select count(*) as pipe_typologies, string_agg(pipe_sewerage_type::Text, ', ' ORDER BY pipe_sewerage_type) as typologies, geom as the_geom from nodes group by geom)
select distinct on (the_geom) c.*, a.manh_connection_node_id, a.manh_display_name from count_nodes_pipe_typologies c, v2_manhole_view a where pipe_typologies > 1 and a.the_geom && c.the_geom;

-- Leidingen met verhang groter dan opgegeven waarde
DROP TABLE IF EXISTS chk.leiding_groot_verhang;
CREATE TABLE chk.leiding_groot_verhang AS
SELECT ST_Length(the_geom)/abs(pipe_invert_level_start_point - pipe_invert_level_end_point) as verhang, *
FROM v2_pipe_view
WHERE pipe_invert_level_start_point != pipe_invert_level_end_point
	AND (ST_Length(the_geom)/abs(pipe_invert_level_start_point - pipe_invert_level_end_point))
		< {max_verhang};

-- Dekking minder dan een bepaalde dekking voor start_node
DROP TABLE IF EXISTS chk.leiding_check_dekking_start;
CREATE TABLE chk.leiding_check_dekking_start AS
SELECT round((surface_level - pipe_invert_level_start_point -
		(	CASE WHEN def_shape = 2 THEN def_width::double precision
			WHEN def_shape = 3 THEN def_height::double precision
			WHEN def_shape > 4 THEN array_greatest(string_to_array(def_height,' '))::double precision
			ELSE 0
			END
		))::numeric,3)  as dekking,
		round((maaiveld - pipe_invert_level_start_point -
		(	CASE WHEN def_shape = 2 THEN def_width::double precision
			WHEN def_shape = 3 THEN def_height::double precision
			WHEN def_shape > 4 THEN array_greatest(string_to_array(def_height,' '))::double precision
			ELSE 0
			END
		))::numeric,3)  as dekking_mv,
		round((pipe_invert_level_end_point +
		(	CASE WHEN def_shape = 2 THEN def_width::double precision
			WHEN def_shape = 3 THEN def_height::double precision
			WHEN def_shape > 4 THEN array_greatest(string_to_array(def_height,' '))::double precision
			ELSE 0
			END
		))::numeric,3) as bob_plus_hoogte,
		round(surface_level::numeric,3) as model_maaiveld, maaiveld as dem_maaiveld,
		(	CASE WHEN def_shape = 2 THEN def_width::double precision
			WHEN def_shape = 3 THEN def_height::double precision
			WHEN def_shape > 4 THEN array_greatest(string_to_array(def_height,' '))::double precision
			ELSE 0
			END
		) as profiel_hoogte,
		v2_pipe_view.*
FROM v2_pipe_view, src.manhole_maaiveld sm JOIN v2_manhole vm ON vm.id = sm.manh_id
WHERE round((surface_level - pipe_invert_level_start_point -
		(	CASE WHEN def_shape = 2 THEN def_width::double precision
			WHEN def_shape = 3 THEN def_height::double precision
			WHEN def_shape > 4 THEN array_greatest(string_to_array(def_height,' '))::double precision
			ELSE 0
			END
		))::numeric,3)
		< {min_dekking}
	AND (sm.manh_id = pipe_connection_node_start_id
	AND pipe_invert_level_start_point IS NOT NULL
	AND vm.surface_level IS NOT NULL);


-- Dekking minder dan een bepaalde dekking voor end_node
DROP TABLE IF EXISTS chk.leiding_check_dekking_end;
CREATE TABLE chk.leiding_check_dekking_end AS
SELECT round((surface_level - pipe_invert_level_end_point -
		(	CASE WHEN def_shape = 2 THEN def_width::double precision
			WHEN def_shape = 3 THEN def_height::double precision
			WHEN def_shape > 4 THEN array_greatest(string_to_array(def_height,' '))::double precision
			ELSE 0
			END
		))::numeric,3)  as dekking,
		round((maaiveld - pipe_invert_level_end_point -
		(	CASE WHEN def_shape = 2 THEN def_width::double precision
			WHEN def_shape = 3 THEN def_height::double precision
			WHEN def_shape > 4 THEN array_greatest(string_to_array(def_height,' '))::double precision
			ELSE 0
			END
		))::numeric,3)  as dekking_mv,
		round((pipe_invert_level_end_point +
		(	CASE WHEN def_shape = 2 THEN def_width::double precision
			WHEN def_shape = 3 THEN def_height::double precision
			WHEN def_shape > 4 THEN array_greatest(string_to_array(def_height,' '))::double precision
			ELSE 0
			END
		))::numeric,3) as bob_plus_hoogte, round(surface_level::numeric,3) as model_maaiveld, maaiveld as dem_maaiveld,
		(	CASE WHEN def_shape = 2 THEN def_width::double precision
			WHEN def_shape = 3 THEN def_height::double precision
			WHEN def_shape > 4 THEN array_greatest(string_to_array(def_height,' '))::double precision
			ELSE 0
			END
		) as profiel_hoogte,
		v2_pipe_view.*
FROM v2_pipe_view, src.manhole_maaiveld sm JOIN v2_manhole vm ON vm.id = sm.manh_id
WHERE round((surface_level - pipe_invert_level_end_point -
		(	CASE WHEN def_shape = 2 THEN def_width::double precision
			WHEN def_shape = 3 THEN def_height::double precision
			WHEN def_shape > 4 THEN array_greatest(string_to_array(def_height,' '))::double precision
			ELSE 0
			END
		))::numeric,3)
		< {min_dekking}
	AND (sm.manh_id = pipe_connection_node_end_id
	AND pipe_invert_level_end_point IS NOT NULL
	AND vm.surface_level IS NOT NULL);

""",
    "sql_quality_pumpstation": """
------------------- Gemalen ------------------------
----------------------------------------------------
-- Aanslagpeil > afslagpeil
DROP TABLE IF EXISTS chk.pomp_aan_vs_af;
CREATE TABLE chk.pomp_aan_vs_af AS
SELECT * FROM v2_pumpstation_point_view WHERE start_level < lower_stop_level;

-- Afslagpeil < bok => pomp slaat nooit af
DROP TABLE IF EXISTS chk.pomp_af_vs_bok;
CREATE TABLE chk.pomp_af_vs_bok AS
SELECT lower_stop_level as afslagpeil, bottom_level, v2_pumpstation_point_view.* FROM v2_pumpstation_point_view, v2_manhole sm WHERE (lower_stop_level < sm.bottom_level AND sm.connection_node_id = connection_node_start_id);

-- Aanslagpeil > maaiveld
DROP TABLE IF EXISTS chk.pomp_aan_vs_maaiveld;
CREATE TABLE chk.pomp_aan_vs_maaiveld AS
SELECT start_level as aanslagpeil, round(vm.surface_level::numeric,3) as model_maaiveld, maaiveld as dem_maaiveld, v2_pumpstation_point_view.* FROM v2_pumpstation_point_view, src.manhole_maaiveld sm JOIN v2_manhole vm ON vm.id = sm.manh_id WHERE (start_level > vm.surface_level AND sm.manh_id = connection_node_start_id);

""",
    "sql_quality_weir": """
----------------- Overstorten ----------------------
----------------------------------------------------

-- Vrije overstorthoogte; drempelhoogte boven maaiveld
drop table if exists chk.overstort_drempel_boven_maaiveld;
CREATE table chk.overstort_drempel_boven_maaiveld as
SELECT wr.weir_display_name, wr.weir_crest_level, vm.surface_level as model_maaiveld, maaiveld as dem_maaiveld, vm.drain_level as original_maaiveld,
 CASE WHEN wr.weir_connection_node_start_id = sm.manh_id THEN 'start'
	WHEN wr.weir_connection_node_end_id = sm.manh_id THEN 'end'
 END as start_or_end,
 CASE WHEN (wr.weir_crest_level > vm.surface_level AND wr.weir_crest_level > maaiveld) THEN 'both'
	WHEN wr.weir_crest_level > vm.surface_level THEN 'model'
	WHEN wr.weir_crest_level > maaiveld THEN 'dem'
 END as maaiveld_type, wr.the_geom
FROM v2_weir_view wr JOIN src.manhole_maaiveld sm ON (wr.weir_connection_node_start_id = sm.manh_id OR wr.weir_connection_node_end_id = sm.manh_id )
JOIN v2_manhole vm ON sm.manh_id = vm.connection_node_id
WHERE wr.weir_crest_level > vm.surface_level OR (wr.weir_crest_level > maaiveld AND round((maaiveld - surface_level)::numeric,2)> {hoogte_verschil}) AND manhole_indicator != 1
ORDER BY start_or_end DESC;

-- Overstorthoogte < bok
drop table if exists chk.overstort_drempel_onder_bok;
CREATE table chk.overstort_drempel_onder_bok as
SELECT wr.weir_display_name, wr.weir_crest_level, sm.connection_node_id, sm.bottom_level, wr.the_geom
FROM v2_weir_view wr
JOIN v2_manhole sm ON wr.weir_connection_node_start_id = sm.connection_node_id
WHERE weir_crest_level < sm.bottom_level;

-- overstort lengte;
DROP TABLE IF EXISTS chk.overstort_korte_lengte;
CREATE table chk.overstort_korte_lengte as
SELECT ST_Length(the_geom), * FROM v2_weir_view WHERE ST_Length(the_geom) < {min_length};

-- dit zijn alle overstorten die door de import sufhyd tool zijn gecreeerd. Van deze overstorten ontbreekt er een eindknoop in het sufhyd.
drop table if exists chk.overstort_verkeerd_uit_sufhyd;
create table chk.overstort_verkeerd_uit_sufhyd as
SELECT ST_Length(the_geom), * FROM v2_weir_view WHERE ST_Length(the_geom) = 1;


""",
    "sql_quality_orifice": """
------------------- Doorlaten ----------------------
----------------------------------------------------
-- openingshoogte boven maaiveld
drop table if exists chk.doorlaat_drempel_boven_maaiveld;
CREATE table chk.doorlaat_drempel_boven_maaiveld as
SELECT ori.orf_display_name, ori.orf_crest_level, vm.connection_node_id, vm.surface_level as model_maaiveld, maaiveld as dem_maaiveld,
 CASE WHEN ori.orf_connection_node_start_id = sm.manh_id THEN 'start'
	WHEN ori.orf_connection_node_end_id = sm.manh_id THEN 'end'
 END as start_or_end,
 CASE WHEN (ori.orf_crest_level > vm.surface_level AND ori.orf_crest_level > maaiveld) THEN 'both'
	WHEN ori.orf_crest_level > vm.surface_level THEN 'model'
	WHEN ori.orf_crest_level > maaiveld THEN 'dem'
 END as maaiveld_type, ori.the_geom
FROM v2_orifice_view ori JOIN src.manhole_maaiveld sm ON (ori.orf_connection_node_start_id = sm.manh_id OR ori.orf_connection_node_end_id = sm.manh_id)
JOIN v2_manhole_view vm ON sm.manh_connection_node_id = vm.connection_node_id
WHERE ori.orf_crest_level > vm.surface_level OR (ori.orf_crest_level > maaiveld AND round((maaiveld - surface_level)::numeric,2)> {hoogte_verschil});

drop table if exists chk.doorlaat_drempel_boven_maaiveld;
CREATE table chk.doorlaat_drempel_boven_maaiveld as
SELECT ori.orf_display_name, ori.orf_crest_level, sm.surface_level, ori.the_geom
FROM v2_orifice_view ori JOIN v2_manhole sm ON ori.orf_connection_node_start_id = sm.connection_node_id
WHERE ori.orf_crest_level > sm.surface_level;

-- Openingshoogte < bok
drop table if exists chk.doorlaat_drempel_onder_bok;
CREATE table chk.doorlaat_drempel_onder_bok as
SELECT ori.orf_display_name, ori.orf_crest_level, sm.connection_node_id, sm.bottom_level, ori.the_geom
FROM v2_orifice_view ori
JOIN v2_manhole sm ON (ori.orf_connection_node_start_id = sm.connection_node_id OR ori.orf_connection_node_end_id = sm.connection_node_id)
WHERE orf_crest_level < sm.bottom_level;

DROP TABLE IF EXISTS chk.doorlaat_korte_lengte;
CREATE table chk.doorlaat_korte_lengte as
SELECT ST_Length(the_geom), * FROM v2_orifice_view WHERE ST_Length(the_geom) < {min_length};

""",
    "sql_quality_cross_section_definition": """
------------------- Doorsnedes ---------------------
----------------------------------------------------
-- kunstwerken met diameter kleiner dan X cm
-- check for 0 values
DROP TABLE IF EXISTS chk.profiel_kleine_breedte;
CREATE TABLE chk.profiel_kleine_breedte AS
SELECT width::float as least_width, *
FROM v2_cross_section_definition_rio_view
WHERE width::float < {min_dimensions}::float AND shape < 5
UNION ALL
SELECT array_greatest(string_to_array(width,' '))::float as greatest_width,*
FROM v2_cross_section_definition_rio_view
WHERE array_greatest(string_to_array(width,' '))::float < {min_dimensions}::float AND shape > 4;

DROP TABLE IF EXISTS chk.profiel_kleine_hoogte;
CREATE TABLE chk.profiel_kleine_hoogte AS
SELECT height::float as least_height, *
FROM v2_cross_section_definition_rio_view
WHERE height::float < {min_dimensions}::float AND shape < 5
UNION ALL
SELECT array_greatest(string_to_array(height,' '))::float as greatest_height,*
FROM v2_cross_section_definition_rio_view
WHERE array_greatest(string_to_array(height,' '))::float < {min_dimensions}::float AND shape > 4;

DROP TABLE IF EXISTS chk.profiel_grote_breedte;
CREATE TABLE chk.profiel_grote_breedte AS
SELECT width::float as greatest_width, *
FROM v2_cross_section_definition_rio_view
WHERE width::float > {max_dimensions}::float AND shape < 5
UNION ALL
SELECT array_greatest(string_to_array(width,' '))::float as greatest_width,*
FROM v2_cross_section_definition_rio_view
WHERE array_greatest(string_to_array(width,' '))::float > {max_dimensions} AND shape > 4;

DROP TABLE IF EXISTS chk.profiel_grote_hoogte;
CREATE TABLE chk.profiel_grote_hoogte AS
SELECT width::float as greatest_height, *
FROM v2_cross_section_definition_rio_view
WHERE height::float > {max_dimensions}::float AND shape < 5
UNION ALL
SELECT array_greatest(string_to_array(height,' '))::float as greatest_height,*
FROM v2_cross_section_definition_rio_view
WHERE array_greatest(string_to_array(height,' '))::float > {max_dimensions}::float AND shape > 4;

""",
}
