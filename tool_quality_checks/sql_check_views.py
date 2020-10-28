# -*- coding: utf-8 -*-

sql_checks = {
    "sql_completeness_manhole": """
------------------- Putten -------------------------
----------------------------------------------------
-- Maaiveldhoogte aanwezig
CREATE OR REPLACE VIEW {schema}.put_maaiveldniveau_leeg AS
    SELECT
        a.code AS rioolput,
        a.id AS threedi_id,
        surface_level AS maaiveldhoogte,
	    NULL::text AS status,
        b.the_geom::geometry(Point, 28992)
    FROM v2_manhole a JOIN v2_connection_nodes b ON a.connection_node_id = b.id
    WHERE surface_level IS NULL;
-- putbodem aanwezig
CREATE OR REPLACE VIEW {schema}.put_bodemhoogte_leeg AS
    SELECT
        a.code AS rioolput,
        a.id AS threedi_id,
        bottom_level AS bodemhoogte,
	    NULL::text AS status,
        b.the_geom::geometry(Point, 28992)
    FROM v2_manhole a JOIN v2_connection_nodes b ON a.connection_node_id = b.id
    WHERE bottom_level IS NULL;
-- Vorm aanwezig
CREATE OR REPLACE VIEW {schema}.put_vorm_leeg AS
    SELECT
        a.code AS rioolput,
        a.id AS threedi_id,
        shape AS vorm,
        'vorm ontbreekt'::text AS bericht,
	    NULL::text AS status,
        b.the_geom::geometry(Point, 28992)
    FROM v2_manhole a JOIN v2_connection_nodes b ON a.connection_node_id = b.id
    WHERE shape IS NULL;
-- putten zonder afmeting
CREATE OR REPLACE VIEW {schema}.put_afmeting_leeg AS
    SELECT
        a.code AS rioolput,
        a.id AS threedi_id,
        CASE
            WHEN shape = '00' or shape = '02' THEN 'rechthoekig'
            WHEN shape = '01' THEN 'rond'
            WHEN shape IS NULL THEN NULL
            ELSE 'overige'
 		END as vorm,
        (width * 1000)::double precision AS breedte,
        (length * 1000)::double precision AS lengte,
        CASE 
            WHEN width IS NULL THEN 'breedte ontbreekt'::text
            WHEN (width IS NULL OR length IS NULL) AND shape = '02' THEN 'rechthoekig: breedte of lengte ontbreekt'::text
        END AS bericht,
	    NULL::text AS status,
        b.the_geom::geometry(Point, 28992)
    FROM v2_manhole a JOIN v2_connection_nodes b ON a.connection_node_id = b.id
    WHERE (width IS NULL) OR ((width IS NULL OR length IS NULL) AND shape = '02');
""",
    "sql_completeness_pipe": """
----------------- Leidingen ------------------------
----------------------------------------------------
-- check begin- en eindpunt aanwezig
CREATE OR REPLACE VIEW {schema}.leiding_punten_leeg AS
    SELECT
        pipe.code AS leiding,
        pipe.id AS threedi_id,
        start_node.code AS beginpunt,
        end_node.code AS eindpunt,
        CASE
            WHEN pipe.connection_node_start_id IS NULL AND pipe.connection_node_end_id IS NOT NULL THEN 'beginpunt ontbreekt'::text
            WHEN pipe.connection_node_start_id IS NOT NULL AND pipe.connection_node_end_id IS NULL THEN 'eindpunt ontbreekt'::text
            WHEN pipe.connection_node_start_id IS NULL AND pipe.connection_node_end_id IS NULL THEN 'begin en eindpunt ontbreken'::text
            ELSE NULL
        END AS bericht,
	    NULL::text AS status
    FROM v2_pipe pipe
    LEFT JOIN v2_connection_nodes start_node
        ON 	pipe.connection_node_start_id = start_node.id 
    LEFT JOIN v2_connection_nodes end_node
        ON 	pipe.connection_node_end_id = end_node.id
    WHERE pipe.connection_node_start_id IS NULL OR pipe.connection_node_end_id IS NULL;
-- BOB's aanwezig
CREATE OR REPLACE VIEW {schema}.leiding_bob_leeg AS
    SELECT
        pipe.code AS leiding,
        pipe.id AS threedi_id,
        pipe.connection_node_start_id AS threedi_start_id,
        pipe.connection_node_end_id AS threedi_end_id,
        start_node.code AS beginpunt,
        end_node.code AS eindpunt,
        pipe.invert_level_start_point AS bob_beginpunt,
        pipe.invert_level_end_point AS bob_eindpunt,
        (array_greatest(string_to_array(height,' '))::float * 1000)::double precision AS hoogte,
        CASE
            WHEN pipe.invert_level_start_point IS NULL AND pipe.invert_level_end_point IS NOT NULL THEN 'bob beginpunt ontbreekt'::text
            WHEN pipe.invert_level_start_point IS NOT NULL AND pipe.invert_level_end_point IS NULL THEN 'bob eindpunt ontbreekt'::text
            WHEN pipe.invert_level_start_point IS NULL AND pipe.invert_level_end_point IS NULL THEN 'bob begin en eindpunt ontbreken'::text
            ELSE NULL
        END AS bericht,
	    NULL::text AS status,
        st_makeline(start_node.the_geom, end_node.the_geom)::geometry(Linestring, 28992) AS the_geom
    FROM v2_pipe pipe
    JOIN v2_connection_nodes start_node
        ON 	pipe.connection_node_start_id = start_node.id
    JOIN v2_connection_nodes end_node
        ON 	pipe.connection_node_end_id = end_node.id
    LEFT JOIN v2_cross_section_definition def
        ON pipe.cross_section_definition_id = def.id
    WHERE pipe.invert_level_start_point IS NULL OR pipe.invert_level_end_point IS NULL;
-- Dwarsdoorsnede ontbreekt
CREATE OR REPLACE VIEW {schema}.leiding_dwarsdoorsnede_leeg AS
    SELECT
        pipe.code AS leiding,
        pipe.id AS threedi_id,
        start_node.code AS beginpunt,
        end_node.code AS eindpunt,
        'dwarsdoorsnede ontbreekt'::text AS bericht,
	    NULL::text AS status,
        st_makeline(start_node.the_geom, end_node.the_geom)::geometry(Linestring, 28992) AS the_geom
    FROM v2_pipe pipe
    JOIN v2_connection_nodes start_node
        ON 	pipe.connection_node_start_id = start_node.id
    JOIN v2_connection_nodes end_node
        ON 	pipe.connection_node_end_id = end_node.id
    WHERE cross_section_definition_id IS NULL;
-- Riooltype ontbreekt
CREATE OR REPLACE VIEW {schema}.leiding_riooltype_leeg AS
    SELECT
        pipe.code AS leiding,
        pipe.id AS threedi_id,
        pipe.connection_node_start_id AS threedi_start_id,
        pipe.connection_node_end_id AS threedi_end_id,
        start_node.code AS beginpunt,
        end_node.code AS eindpunt,
        'riooltype ontbreekt'::text AS bericht,
	    NULL::text AS status,
        st_makeline(start_node.the_geom, end_node.the_geom)::geometry(Linestring, 28992) AS the_geom
    FROM v2_pipe pipe
    JOIN v2_connection_nodes start_node
        ON 	pipe.connection_node_start_id = start_node.id
    JOIN v2_connection_nodes end_node
        ON 	pipe.connection_node_end_id = end_node.id
    WHERE sewerage_type IS NULL;
-- Materiaal ontbreekt
CREATE OR REPLACE VIEW {schema}.leiding_materiaal_leeg AS
    SELECT
        pipe.code AS leiding,
        pipe.id AS threedi_id,
        start_node.code AS beginpunt,
        end_node.code AS eindpunt,
        'materiaal ontbreekt'::text AS bericht,
	    NULL::text AS status,
        st_makeline(start_node.the_geom, end_node.the_geom)::geometry(Linestring, 28992) AS the_geom
    FROM v2_pipe pipe
    JOIN v2_connection_nodes start_node
        ON 	pipe.connection_node_start_id = start_node.id
    JOIN v2_connection_nodes end_node
        ON 	pipe.connection_node_end_id = end_node.id
    WHERE material IS NULL;
-- Dwarsdoorsnede compleet
CREATE OR REPLACE VIEW {schema}.leiding_afmeting_leeg AS
    SELECT
        pipe.code AS leiding,
        pipe.id AS threedi_id,
        start_node.code AS beginpunt,
        end_node.code AS eindpunt,
        CASE
            WHEN shape = 1 THEN 'rechthoekig (open)'::text
            WHEN shape = 2 THEN 'rond'::text
            WHEN shape = 3 THEN 'eivormig'::text
            WHEN shape = 5 THEN 'rechthoekig (getabelleerd)'::text
            WHEN shape = 6 THEN 'getabelleerd trapezium'::text
			WHEN shape = 4 or shape > 6 THEN 'overige'::text
            ELSE NULL
	END as vormprofiel,
        (array_greatest(string_to_array(width,' '))::float * 1000)::double precision AS breedte,
        (array_greatest(string_to_array(height,' '))::float * 1000)::double precision AS hoogte,
        CASE
            WHEN (shape = 4 OR shape > 6) AND width IS NULL THEN 'vorm en breedte ontbreken'::text
            WHEN shape = 4 OR shape > 6 OR shape IS NULL THEN 'vorm ontbreekt'::text
            WHEN width IS NULL THEN 'breedte of diameter ontbreekt'::text
            WHEN height IS NULL THEN 'hoogte ontbreekt'
            ELSE NULL
        END AS bericht,
	    NULL::text AS status,
        st_makeline(start_node.the_geom, end_node.the_geom)::geometry(Linestring, 28992) AS the_geom
    FROM v2_pipe pipe
    JOIN v2_connection_nodes start_node
        ON 	pipe.connection_node_start_id = start_node.id 
    JOIN v2_connection_nodes end_node
        ON 	pipe.connection_node_end_id = end_node.id 
    LEFT JOIN v2_cross_section_definition def
        ON pipe.cross_section_definition_id = def.id
    WHERE shape IS NULL
        OR width IS NULL
        OR (height IS NULL and shape > 2);
""",
    "sql_completeness_weir": """
----------------- Overstorten ----------------------
----------------------------------------------------
-- check begin- en eindpunt aanwezig
CREATE OR REPLACE VIEW {schema}.overstort_punten_leeg AS
    SELECT
        weir.code AS overstort,
        weir.id AS threedi_id,
        start_node.code AS beginpunt,
        end_node.code AS eindpunt,
        CASE
            WHEN weir.connection_node_start_id IS NULL AND weir.connection_node_end_id != NULL THEN 'beginpunt ontbreekt'::text
            WHEN weir.connection_node_start_id != NULL AND weir.connection_node_end_id IS NULL THEN 'eindpunt ontbreekt'::text
            WHEN weir.connection_node_start_id IS NULL AND weir.connection_node_end_id IS NULL THEN 'begin en eindpunt ontbreken'::text
            ELSE NULL
        END AS bericht,
	    NULL::text AS status
    FROM v2_weir weir
    LEFT JOIN v2_connection_nodes start_node
        ON 	weir.connection_node_start_id = start_node.id 
    LEFT JOIN v2_connection_nodes end_node
        ON 	weir.connection_node_end_id = end_node.id 
    LEFT JOIN v2_cross_section_definition def
        ON weir.cross_section_definition_id = def.id
    WHERE weir.connection_node_start_id IS NULL OR weir.connection_node_end_id IS NULL;
-- Drempelhoogte aanwezig
CREATE OR REPLACE VIEW {schema}.overstort_niveau_leeg AS
    SELECT
        weir.code AS overstort,
        weir.id AS threedi_id,
        start_node.code AS beginpunt,
        end_node.code AS eindpunt,
        'drempelniveau ontbreekt'::text AS bericht,
	    NULL::text AS status,
        st_makeline(start_node.the_geom, end_node.the_geom)::geometry(Linestring, 28992) AS the_geom
    FROM v2_weir weir
    JOIN v2_connection_nodes start_node
        ON 	weir.connection_node_start_id = start_node.id 
    JOIN v2_connection_nodes end_node
        ON 	weir.connection_node_end_id = end_node.id 
    LEFT JOIN v2_cross_section_definition def
        ON weir.cross_section_definition_id = def.id
    WHERE weir.crest_level IS NULL;
-- Dwarsdoorsnede ontbreekt
CREATE OR REPLACE VIEW {schema}.overstort_dwarsdoorsnede_leeg AS
    SELECT
        weir.code AS leiding,
        weir.id AS threedi_id,
        start_node.code AS beginpunt,
        end_node.code AS eindpunt,
        'dwarsdoorsnede ontbreekt'::text AS bericht,
	    NULL::text AS status,
        st_makeline(start_node.the_geom, end_node.the_geom)::geometry(Linestring, 28992) AS the_geom
    FROM v2_weir weir
    JOIN v2_connection_nodes start_node
        ON 	weir.connection_node_start_id = start_node.id
    JOIN v2_connection_nodes end_node
        ON 	weir.connection_node_end_id = end_node.id
    WHERE cross_section_definition_id IS NULL;
-- Drempelbreedte aanwezig
CREATE OR REPLACE VIEW {schema}.overstort_breedte_leeg AS
    SELECT
        weir.code AS overstort,
        weir.id AS threedi_id,
        start_node.code AS beginpunt,
        end_node.code AS eindpunt,
        'drempelbreedte ontbreekt'::text AS bericht,
	    NULL::text AS status,
        st_makeline(start_node.the_geom, end_node.the_geom)::geometry(Linestring, 28992) AS the_geom
    FROM v2_weir weir
    JOIN v2_connection_nodes start_node
        ON 	weir.connection_node_start_id = start_node.id 
    JOIN v2_connection_nodes end_node
        ON 	weir.connection_node_end_id = end_node.id 
    LEFT JOIN v2_cross_section_definition def
        ON weir.cross_section_definition_id = def.id
    WHERE def.width IS NULL;
-- Discharge coefficient aanwezig
CREATE OR REPLACE VIEW {schema}.overstort_stroming_leeg AS
    SELECT
        weir.code AS overstort,
        weir.id AS threedi_id,
        start_node.code AS beginpunt,
        end_node.code AS eindpunt,
        CASE
            WHEN discharge_coefficient_positive = 0 AND discharge_coefficient_negative > 0 THEN 'stroming van eindpunt naar beginpunt'::text
            WHEN discharge_coefficient_negative = 0 AND discharge_coefficient_positive > 0 THEN 'stroming van beginpunt naar eindpunt'::text
            WHEN discharge_coefficient_positive > 0 AND discharge_coefficient_negative > 0 THEN 'stroming in beide richtingen'::text
            WHEN discharge_coefficient_positive = 0 AND discharge_coefficient_negative = 0 THEN 'geen stroming'::text
            ELSE NULL
        END AS stromingsrichting,
        CASE
            WHEN discharge_coefficient_positive > discharge_coefficient_negative THEN discharge_coefficient_positive
            WHEN discharge_coefficient_positive < discharge_coefficient_negative THEN discharge_coefficient_negative
            WHEN discharge_coefficient_positive = discharge_coefficient_negative THEN discharge_coefficient_positive
            ELSE NULL
        END AS afvoercoefficient,
        CASE
            WHEN discharge_coefficient_positive IS NULL AND discharge_coefficient_negative IS NULL THEN 'afvoercoefficient ontbreekt'::text
            WHEN discharge_coefficient_positive IS NULL AND discharge_coefficient_negative IS NULL THEN 'stromingsrichting onbekend'::text
            WHEN discharge_coefficient_positive = 0 AND discharge_coefficient_negative = 0 THEN 'geen stroming'::text
            WHEN discharge_coefficient_positive = 0 OR discharge_coefficient_negative = 0 THEN 'eenrichting stroming'::text
            ELSE NULL
        END AS bericht,
	    NULL::text AS status,
        st_makeline(start_node.the_geom, end_node.the_geom)::geometry(Linestring, 28992) AS the_geom
    FROM v2_weir weir
    JOIN v2_connection_nodes start_node
        ON 	weir.connection_node_start_id = start_node.id 
    JOIN v2_connection_nodes end_node
        ON 	weir.connection_node_end_id = end_node.id 
    LEFT JOIN v2_cross_section_definition def
        ON weir.cross_section_definition_id = def.id
    WHERE discharge_coefficient_positive IS NULL
        OR discharge_coefficient_negative IS NULL
        OR discharge_coefficient_positive = 0
        OR discharge_coefficient_negative = 0;
""",
    "sql_completeness_orifice": """
------------------- Doorlaten ----------------------
----------------------------------------------------
-- check begin- en eindpunt aanwezig
CREATE OR REPLACE VIEW {schema}.doorlaat_punten_leeg AS
    SELECT
        orf.code AS doorlaat,
        orf.id AS threedi_id,
        start_node.code AS beginpunt,
        end_node.code AS eindpunt,
        CASE
            WHEN orf.connection_node_start_id IS NULL AND orf.connection_node_end_id != NULL THEN 'beginpunt ontbreekt'::text
            WHEN orf.connection_node_start_id != NULL AND orf.connection_node_end_id IS NULL THEN 'eindpunt ontbreekt'::text
            WHEN orf.connection_node_start_id IS NULL AND orf.connection_node_end_id IS NULL THEN 'begin en eindpunt ontbreken'::text
            ELSE NULL
        END AS bericht,
	    NULL::text AS status
    FROM v2_orifice orf
    LEFT JOIN v2_connection_nodes start_node
        ON 	orf.connection_node_start_id = start_node.id 
    LEFT JOIN v2_connection_nodes end_node
        ON 	orf.connection_node_end_id = end_node.id 
    LEFT JOIN v2_cross_section_definition def
        ON orf.cross_section_definition_id = def.id
    WHERE orf.connection_node_start_id IS NULL OR orf.connection_node_end_id IS NULL;
-- Openingshoogte aanwezig en logisch
CREATE OR REPLACE VIEW {schema}.doorlaat_niveau_leeg AS
    SELECT
        orf.code AS doorlaat,
        orf.id AS threedi_id,
        start_node.code AS beginpunt,
        end_node.code AS eindpunt,
        'doorlaatniveau ontbreekt'::text AS bericht,
	    NULL::text AS status,
        st_makeline(start_node.the_geom, end_node.the_geom)::geometry(Linestring, 28992) AS the_geom
    FROM v2_orifice orf
    JOIN v2_connection_nodes start_node
        ON 	orf.connection_node_start_id = start_node.id 
    JOIN v2_connection_nodes end_node
        ON 	orf.connection_node_end_id = end_node.id 
    LEFT JOIN v2_cross_section_definition def
        ON orf.cross_section_definition_id = def.id
    WHERE orf.crest_level IS NULL;
-- Dwarsdoorsnede ontbreekt
CREATE OR REPLACE VIEW {schema}.doorlaat_vorm_leeg AS
    SELECT
        orf.code AS leiding,
        orf.id AS threedi_id,
        start_node.code AS beginpunt,
        end_node.code AS eindpunt,
        'dwarsdoorsnede ontbreekt'::text AS bericht,
	    NULL::text AS status,
        st_makeline(start_node.the_geom, end_node.the_geom)::geometry(Linestring, 28992) AS the_geom
    FROM v2_orifice orf
    JOIN v2_connection_nodes start_node
        ON 	orf.connection_node_start_id = start_node.id
    JOIN v2_connection_nodes end_node
        ON 	orf.connection_node_end_id = end_node.id
    WHERE cross_section_definition_id IS NULL;
-- Drempelbreedte aanwezig
CREATE OR REPLACE VIEW {schema}.doorlaat_breedte_leeg AS
    SELECT
        orf.code AS doorlaat,
        orf.id AS threedi_id,
        start_node.code AS beginpunt,
        end_node.code AS eindpunt,
        'drempelbreedte ontbreekt'::text AS bericht,
	    NULL::text AS status,
        st_makeline(start_node.the_geom, end_node.the_geom)::geometry(Linestring, 28992) AS the_geom
    FROM v2_orifice orf
    JOIN v2_connection_nodes start_node
        ON 	orf.connection_node_start_id = start_node.id 
    JOIN v2_connection_nodes end_node
        ON 	orf.connection_node_end_id = end_node.id 
    LEFT JOIN v2_cross_section_definition def
        ON orf.cross_section_definition_id = def.id
    WHERE def.width IS NULL;
-- Discharge coefficient en stroming aanwezig
CREATE OR REPLACE VIEW {schema}.doorlaat_stroming_leeg AS
    SELECT
        orf.code AS overstort,
        orf.id AS threedi_id,
        start_node.code AS beginpunt,
        end_node.code AS eindpunt,
        CASE
            WHEN discharge_coefficient_positive = 0 AND discharge_coefficient_negative != 0 THEN 'stroming van eindpunt naar beginpunt'::text
            WHEN discharge_coefficient_negative = 0 AND discharge_coefficient_positive != 0 THEN 'stroming van beginpunt naar eindpunt'::text
            WHEN discharge_coefficient_positive != 0 AND discharge_coefficient_negative != 0 THEN 'stroming in beide richtingen'::text
            WHEN discharge_coefficient_positive = 0 AND discharge_coefficient_negative = 0 THEN 'geen stroming'::text
            ELSE NULL
        END AS stromingsrichting,
        CASE
            WHEN discharge_coefficient_positive > discharge_coefficient_negative THEN discharge_coefficient_positive
            WHEN discharge_coefficient_positive < discharge_coefficient_negative THEN discharge_coefficient_negative
            WHEN discharge_coefficient_positive = discharge_coefficient_negative THEN discharge_coefficient_positive
            ELSE NULL
        END AS contractiecoefficient,
        CASE
            WHEN discharge_coefficient_positive IS NULL AND discharge_coefficient_negative IS NULL THEN 'afvoercoefficient ontbreekt'::text
            WHEN discharge_coefficient_positive IS NULL AND discharge_coefficient_negative IS NULL THEN 'stromingsrichting onbekend'::text
            WHEN discharge_coefficient_positive = 0 AND discharge_coefficient_negative = 0 THEN 'geen stroming'::text
            WHEN discharge_coefficient_positive = 0 OR discharge_coefficient_negative = 0 THEN 'eenrichting stroming'::text
            ELSE NULL
        END AS bericht,
	    NULL::text AS status,
        st_makeline(start_node.the_geom, end_node.the_geom)::geometry(Linestring, 28992) AS the_geom
    FROM v2_orifice orf
    JOIN v2_connection_nodes start_node
        ON 	orf.connection_node_start_id = start_node.id 
    JOIN v2_connection_nodes end_node
        ON 	orf.connection_node_end_id = end_node.id 
    LEFT JOIN v2_cross_section_definition def
        ON orf.cross_section_definition_id = def.id
    WHERE discharge_coefficient_positive IS NULL
        OR discharge_coefficient_negative IS NULL
        OR discharge_coefficient_positive = 0
        OR discharge_coefficient_negative = 0;
""",
    "sql_completeness_pumpstation": """
------------------- Gemalen ------------------------
----------------------------------------------------
-- Aantal pompen
CREATE OR REPLACE VIEW {schema}.pomp_punt_leeg AS
    SELECT
        pump.code AS pomp,
        pump.id AS threedi_id,
        start_node.code AS beginpuntpomp,
        end_node.code AS eindpuntpomp,
	    NULL::text AS status
    FROM v2_pumpstation pump
    LEFT JOIN v2_connection_nodes start_node
        ON 	pump.connection_node_start_id = start_node.id 
    LEFT JOIN v2_connection_nodes end_node
        ON 	pump.connection_node_end_id = end_node.id 
    WHERE connection_node_start_id IS NULL;
-- Aan- en afslagpeil onbekend
CREATE OR REPLACE VIEW {schema}.pomp_aan_afslagpeil_leeg AS
    SELECT
        pump.code AS pomp,
        pump.id AS threedi_id,
        start_node.code AS beginpuntpomp,
        end_node.code AS eindpuntpomp,
        CASE
            WHEN type = 1 THEN start_level
            WHEN type = 2 THEN NULL
            ELSE start_level
	END AS aanslagniveaubovenstrooms,
        CASE
            WHEN type = 1 THEN lower_stop_level
            WHEN type = 2 THEN NULL
            ELSE lower_stop_level
	END AS afslagniveaubovenstrooms,
        CASE
            WHEN type = 1 THEN NULL
            WHEN type = 2 THEN start_level
            ELSE NULL
	END AS aanslagniveaubenedenstrooms,
        CASE
            WHEN type = 1 THEN NULL
            WHEN type = 2 THEN lower_stop_level
            ELSE NULL
	END AS afslagniveaubenedenstrooms,
        CASE
            WHEN start_level IS NULL AND lower_stop_level != NULL THEN 'aanslagniveau ontbreekt'::text
            WHEN start_level != NULL AND lower_stop_level IS NULL THEN 'afslagniveau ontbreekt'::text
            WHEN start_level IS NULL AND lower_stop_level IS NULL THEN 'aan- en afslagniveau ontbreken'::text
            ELSE NULL
	    END AS bericht,
	    NULL::text AS status,
        start_node.the_geom::geometry(Point, 28992)
    FROM v2_pumpstation pump
    JOIN v2_connection_nodes start_node
        ON 	pump.connection_node_start_id = start_node.id 
    LEFT JOIN v2_connection_nodes end_node
        ON 	pump.connection_node_end_id = end_node.id
    WHERE start_level IS NULL OR lower_stop_level IS NULL;
-- capaciteit onbekend
CREATE OR REPLACE VIEW {schema}.pomp_capaciteit_leeg AS
    SELECT
        pump.code AS pomp,
        pump.id AS threedi_id,
        start_node.code AS beginpuntpomp,
        end_node.code AS eindpuntpomp,
        'pompcapaciteit ontbreekt'::text AS bericht,
	    NULL::text AS status,
        start_node.the_geom::geometry(Point, 28992)
    FROM v2_pumpstation pump
    JOIN v2_connection_nodes start_node
        ON 	pump.connection_node_start_id = start_node.id 
    LEFT JOIN v2_connection_nodes end_node
        ON 	pump.connection_node_end_id = end_node.id
    WHERE capacity IS NULL;
""",
    # ---------------------------------------------------
    # ----------- Kwaliteitchecks Riolering -------------
    # ---------------------------------------------------
    "sql_quality_manhole": """
------------------- Putten -------------------------
----------------------------------------------------
-- Maaiveldhoogte logisch
CREATE OR REPLACE VIEW {schema}.put_maaiveldniveau_onlogisch AS
    SELECT
        a.code AS rioolput,
        a.id AS threedi_id,
        surface_level AS maaiveldhoogte,
	    NULL::text AS status,
        b.the_geom::geometry(Point, 28992)
    FROM v2_manhole a JOIN v2_connection_nodes b ON a.connection_node_id = b.id
    WHERE surface_level = 0
	OR surface_level < {min_levels}
	OR surface_level > {max_levels};
-- putbodem logisch
CREATE OR REPLACE VIEW {schema}.put_bodemhoogte_onlogisch AS
    SELECT
        a.code AS rioolput,
        a.id AS threedi_id,
        bottom_level AS bodemhoogte,
	    NULL::text AS status,
        b.the_geom::geometry(Point, 28992)
    FROM v2_manhole a JOIN v2_connection_nodes b ON a.connection_node_id = b.id
    WHERE bottom_level = 0
        OR bottom_level < {min_levels}
        OR bottom_level > {max_levels}
    ORDER BY bottom_level;
-- Afmetingen putten logisch
CREATE OR REPLACE VIEW {schema}.put_afmeting_onlogisch AS
    SELECT
        a.code AS rioolput,
        a.id AS threedi_id,
        shape AS vorm,
        (width * 1000)::double precision AS breedte,
        (length * 1000)::double precision AS lengte,
        CASE 
            WHEN width = 0 THEN 'breedte is nul'::text
            WHEN length = 0 THEN 'lengte is nul'::text
            WHEN width != length AND shape != '02' THEN 'breedte is ongelijk aan lengte'::text
        END AS bericht,
	    NULL::text AS status,
        b.the_geom::geometry(Point, 28992)
    FROM v2_manhole a JOIN v2_connection_nodes b ON a.connection_node_id = b.id
    WHERE width = 0 OR length = 0 OR (width != length AND shape != '02');
-- Check putten buiten de dem
CREATE OR REPLACE VIEW {schema}.put_buiten_dem AS
    SELECT
        a.code AS rioolput,
        a.id AS threedi_id,
	    NULL::text AS status,
        b.the_geom::geometry(Point, 28992)
    FROM v2_manhole a
    JOIN v2_connection_nodes b
        ON a.connection_node_id = b.id
    LEFT JOIN src.manhole_maaiveld c
        ON a.id = c.manh_id
    WHERE maaiveld IS NULL or maaiveld = -9999;
-- betrouwbaarheid maaiveldhoogte put tov AHN
CREATE OR REPLACE VIEW {schema}.put_maaiveld_vs_ahn AS
    SELECT
        a.code AS rioolput,
        a.id AS threedi_id,
        round(surface_level::numeric,2) AS put_maaiveldhoogte,
        maaiveld AS ahn_maaiveldhoogte,
        round((maaiveld - surface_level)::numeric,2) AS hoogte_verschil,
	    NULL::text AS status,
        b.the_geom::geometry(Point, 28992)
    FROM v2_manhole a
    JOIN v2_connection_nodes b
        ON 	a.connection_node_id = b.id 
    LEFT JOIN src.manhole_maaiveld c
        ON 	a.id = c.manh_id
    WHERE maaiveld != -9999 AND abs(maaiveld - surface_level) > {hoogte_verschil};
-- Maaiveldhoogte > putbodem
CREATE OR REPLACE VIEW {schema}.put_maaiveld_vs_bodemhoogte AS
    SELECT
        a.code AS rioolput,
        a.id AS threedi_id,
        CASE
            WHEN manhole_indicator = 0 THEN 'inspectieput'
            WHEN manhole_indicator = 1 THEN 'uitlaat'
            WHEN manhole_indicator = 2 THEN 'pomp'
            WHEN manhole_indicator IS NULL THEN NULL
            ELSE 'overige'
	END as typeknooppunt,
        bottom_level AS bodemhoogte,
        surface_level AS maaiveldhoogte,
        surface_level - bottom_level AS hoogte_verschil,
        {min_dekking} AS minimale_dekking,
	    NULL::text AS status,
        b.the_geom::geometry(Point, 28992)
    FROM v2_manhole a JOIN v2_connection_nodes b ON a.connection_node_id = b.id
    WHERE surface_level < bottom_level + {min_dekking}
    ORDER BY (surface_level - bottom_level);
-- BOK > laagste bob
-- first join the start bob's
-- then select the lowest
CREATE OR REPLACE VIEW {schema}.put_bodemhoogte_vs_bob AS
    WITH bob_invert_levels AS(
    SELECT
        a.code AS rioolput,
        a.id AS threedi_id,
        CASE
            WHEN manhole_indicator = 0 THEN 'inspectieput'
            WHEN manhole_indicator = 1 THEN 'uitlaat'
            WHEN manhole_indicator = 2 THEN 'pomp'
            WHEN manhole_indicator IS NULL THEN NULL
            ELSE 'overige'
	    END as typeknooppunt,
        bottom_level AS bodemhoogte,
        surface_level AS maaiveldhoogte,
	CASE
            WHEN a.connection_node_id = c.connection_node_start_id::integer THEN c.invert_level_start_point
	    WHEN a.connection_node_id = c.connection_node_end_id::integer THEN c.invert_level_end_point
            ELSE NULL
        END AS bob_hoogte,
	    NULL::text AS status,
        b.the_geom::geometry(Point, 28992)
    FROM v2_manhole a
    JOIN v2_connection_nodes b
        ON a.connection_node_id = b.id
    LEFT JOIN v2_pipe c
        ON a.connection_node_id = c.connection_node_start_id::integer OR a.connection_node_id = c.connection_node_end_id::integer
    ORDER BY a.id, c.id
    )
    SELECT DISTINCT ON (threedi_id) * FROM bob_invert_levels WHERE bodemhoogte > bob_hoogte
    ORDER BY threedi_id, bob_hoogte ASC;
-- Afmeting buis > grootste aangesloten diameter
-- first join aangesloten diameters
-- then select the lowest
CREATE OR REPLACE VIEW {schema}.put_afm_vs_leiding_afm AS
    WITH aangesloten_diameters AS(
    SELECT
        a.code AS rioolput,
        a.id AS threedi_id,
        CASE
            WHEN manhole_indicator = 0 THEN 'inspectieput'
            WHEN manhole_indicator = 1 THEN 'uitlaat'
            WHEN manhole_indicator = 2 THEN 'pomp'
            WHEN manhole_indicator IS NULL THEN NULL
            ELSE 'overige'
	    END as typeknooppunt,
        (a.width * 1000)::double precision AS breedte_put,
        (a.length * 1000)::double precision AS lengte_put,
        (greatest(a.width, a.length) * 1000)::double precision AS grootste_put_afmeting,
        (array_greatest(string_to_array(d.width,' '))::float * 1000)::double precision AS breedte_leiding,
	    NULL::text AS status,
        b.the_geom::geometry(Point, 28992)
    FROM v2_manhole a
    JOIN v2_connection_nodes b
        ON a.connection_node_id = b.id
    LEFT JOIN v2_pipe c
        ON a.connection_node_id = c.connection_node_start_id::integer OR a.connection_node_id = c.connection_node_end_id::integer
    LEFT JOIN v2_cross_section_definition d
        ON c.cross_section_definition_id = d.id
    ORDER BY a.id, c.id
    )
    SELECT DISTINCT ON (threedi_id) * 
    FROM aangesloten_diameters 
    WHERE (grootste_put_afmeting < breedte_leiding + {padding_manhole}) AND (grootste_put_afmeting > 0)
    ORDER BY threedi_id, breedte_leiding DESC;
-- Dubbele putten
CREATE OR REPLACE VIEW {schema}.put_dubbel AS
    WITH dubbele_put AS (
        SELECT
            the_geom::geometry(Point, 28992),
            count(*) as aantal
        FROM v2_connection_nodes
        GROUP BY the_geom
        HAVING count(*) > 1)
    SELECT
        b.id as threedi_connection_node_id,
        aantal,
		NULL::text AS status,
        b.the_geom::geometry(Point, 28992)
    FROM v2_manhole a JOIN v2_connection_nodes b ON a.connection_node_id = b.id, dubbele_put c
    WHERE b.the_geom && c.the_geom;
-- Putten binnen 20 cm van elkaar
CREATE OR REPLACE VIEW {schema}.put_kleine_afstand AS
    SELECT
        DISTINCT ON (a.id) a.id,
        rioolput_een.code AS rioolput_een,
        rioolput_twee.code AS rioolput_twee,
        rioolput_een.id AS threedi_id_een,
        rioolput_twee.id AS threedi_id_twee,
        ST_Distance(a.the_geom, b.the_geom) AS afstand,
	    NULL::text AS status,
        a.the_geom::geometry(Point, 28992)
    FROM v2_connection_nodes a
    JOIN v2_connection_nodes b
        ON ST_DWithin(a.the_geom, b.the_geom,0.2)
    LEFT JOIN v2_manhole rioolput_een
        ON rioolput_een.connection_node_id = a.id
    LEFT JOIN v2_manhole rioolput_twee
        ON rioolput_twee.connection_node_id = b.id
    WHERE (a.id < b.id) AND (ST_Distance(a.the_geom, b.the_geom) > 0)
    ORDER BY a.id, ST_Distance(a.the_geom, b.the_geom);
-- Losliggende putten
CREATE OR REPLACE VIEW {schema}.put_losliggend AS
    SELECT
        a.code AS rioolput,
        a.id AS threedi_id,
	    NULL::text AS status,
        b.the_geom::geometry(Point, 28992)
    FROM v2_manhole a JOIN v2_connection_nodes b ON a.connection_node_id = b.id
    WHERE
        (b.id NOT IN (SELECT connection_node_start_id FROM v2_pipe WHERE connection_node_start_id IS NOT NULL)
        AND b.id NOT IN (SELECT connection_node_end_id FROM v2_pipe WHERE connection_node_end_id  IS NOT NULL)
        AND b.id NOT IN (SELECT connection_node_start_id FROM v2_weir WHERE connection_node_start_id IS NOT NULL)
        AND b.id NOT IN (SELECT connection_node_end_id FROM v2_weir WHERE connection_node_end_id IS NOT NULL)
        AND b.id NOT IN (SELECT connection_node_start_id FROM v2_orifice WHERE connection_node_start_id IS NOT NULL)
        AND b.id NOT IN (SELECT connection_node_end_id FROM v2_orifice WHERE connection_node_end_id  IS NOT NULL)
        AND b.id NOT IN (SELECT connection_node_start_id FROM v2_culvert WHERE connection_node_start_id IS NOT NULL)
        AND b.id NOT IN (SELECT connection_node_end_id FROM v2_culvert WHERE connection_node_end_id  IS NOT NULL)
        AND b.id NOT IN (SELECT connection_node_start_id FROM v2_channel WHERE connection_node_start_id IS NOT NULL)
        AND b.id NOT IN (SELECT connection_node_end_id FROM v2_channel WHERE connection_node_end_id  IS NOT NULL));
-- aantal inkomende leidingen
CREATE OR REPLACE VIEW {schema}.put_inkomende_leidingen AS
    WITH verbindingen AS (
        SELECT
            point::geometry(Point, 28992) AS geom,
            count(*) AS nr_con,
            array_to_string(array_agg(DISTINCT line_type), ', ') AS line_types
        FROM (
            SELECT
                start_pipe.the_geom::geometry(Point, 28992) AS point,
                'leiding' AS line_type
            FROM v2_pipe pipe JOIN v2_connection_nodes start_pipe ON pipe.connection_node_start_id = start_pipe.id 
            UNION ALL
            SELECT
                end_pipe.the_geom::geometry(Point, 28992) AS point,
                'leiding' AS line_type
            FROM v2_pipe pipe JOIN v2_connection_nodes end_pipe ON pipe.connection_node_end_id = end_pipe.id 
            UNION ALL
            SELECT
                start_weir.the_geom::geometry(Point, 28992) AS point,
                'overstort' AS line_type
            FROM v2_weir weir JOIN v2_connection_nodes start_weir ON weir.connection_node_start_id = start_weir.id 
            UNION ALL
            SELECT
                end_weir.the_geom::geometry(Point, 28992) AS point,
                'overstort' AS line_type
            FROM v2_weir weir JOIN v2_connection_nodes end_weir ON weir.connection_node_end_id = end_weir.id 
            UNION ALL
            SELECT
                start_orf.the_geom::geometry(Point, 28992) AS point,
                'doorlaat' AS line_type
            FROM v2_orifice orf JOIN v2_connection_nodes start_orf ON orf.connection_node_start_id = start_orf.id 
            UNION ALL
            SELECT
                end_orf.the_geom::geometry(Point, 28992) AS point,
                'doorlaat' AS line_type
            FROM v2_orifice orf JOIN v2_connection_nodes end_orf ON orf.connection_node_end_id = end_orf.id
        ) AS a
    GROUP BY geom
    HAVING count(*) > 1),
nr_connections AS (
    SELECT
        c.code AS rioolput,
        c.id AS threedi_id,
        b.nr_con AS aantal_verbindingen,
        b.line_types AS type_verbindingen,
	    NULL::text AS status,
        a.the_geom::geometry(Point, 28992)
    FROM
        v2_connection_nodes AS a JOIN v2_manhole c ON a.id = c.connection_node_id,
        verbindingen AS b
    WHERE a.the_geom && b.geom)
    SELECT * from nr_connections AS n WHERE aantal_verbindingen > {max_connections}
    ORDER BY aantal_verbindingen DESC;
-------------------- Uitlaten ----------------------
----------------------------------------------------
-- Uitlaat verbonden aan meedere kunstwerken
CREATE OR REPLACE VIEW {schema}.put_uitlaat_meerdere_verbindingen AS
    WITH verbindingen AS (
        SELECT
            point::geometry(Point, 28992) AS geom
        FROM (
            SELECT
                start_pipe.the_geom::geometry(Point, 28992) AS point
            FROM v2_pipe pipe JOIN v2_connection_nodes start_pipe ON pipe.connection_node_start_id = start_pipe.id 
            UNION ALL
            SELECT
                end_pipe.the_geom::geometry(Point, 28992) AS point
            FROM v2_pipe pipe JOIN v2_connection_nodes end_pipe ON pipe.connection_node_end_id = end_pipe.id 
            UNION ALL
            SELECT
                start_weir.the_geom::geometry(Point, 28992) AS point
            FROM v2_weir weir JOIN v2_connection_nodes start_weir ON weir.connection_node_start_id = start_weir.id 
            UNION ALL
            SELECT
                end_weir.the_geom::geometry(Point, 28992) AS point
            FROM v2_weir weir JOIN v2_connection_nodes end_weir ON weir.connection_node_end_id = end_weir.id 
            UNION ALL
            SELECT
                start_orf.the_geom::geometry(Point, 28992) AS point
            FROM v2_orifice orf JOIN v2_connection_nodes start_orf ON orf.connection_node_start_id = start_orf.id 
            UNION ALL
            SELECT
                end_orf.the_geom::geometry(Point, 28992) AS point
            FROM v2_orifice orf JOIN v2_connection_nodes end_orf ON orf.connection_node_end_id = end_orf.id
        ) AS a
    GROUP BY geom
    HAVING count(*) > 1)
SELECT
    c.code AS rioolput,
    a.id AS threedi_id,
    CASE
        WHEN c.manhole_indicator = 0 THEN 'inspectieput'
        WHEN c.manhole_indicator = 1 THEN 'uitlaat'
        WHEN c.manhole_indicator = 2 THEN 'pomp'
        WHEN c.manhole_indicator IS NULL THEN NULL
        ELSE 'overige'
    END as typeknooppunt,
	NULL::text AS status,
    a.the_geom::geometry(Point, 28992)
FROM
    v2_connection_nodes AS a JOIN v2_manhole c ON a.id = c.connection_node_id,
    verbindingen AS b
WHERE ST_intersects(a.the_geom, b.geom) AND c.connection_node_id IN (SELECT connection_node_id FROM v2_1d_boundary_conditions);
-- Uitlaat aan eindpunt gemaal
CREATE OR REPLACE VIEW {schema}.put_uitlaat_op_eindpunt_gemaal AS
    SELECT
        a.code AS rioolput,
        a.id AS threedi_id,
        CASE
            WHEN b.manhole_indicator = 0 THEN 'inspectieput'
            WHEN b.manhole_indicator = 1 THEN 'uitlaat'
            WHEN b.manhole_indicator = 2 THEN 'pomp'
            WHEN b.manhole_indicator IS NULL THEN NULL
            ELSE 'overige'
	    END as typeknooppunt,
	    NULL::text AS status,
        a.the_geom::geometry(Point, 28992)
    FROM v2_connection_nodes a
    LEFT JOIN v2_manhole b
        ON 	b.connection_node_id = a.id 
    LEFT JOIN v2_pumpstation c
        ON 	c.connection_node_end_id = a.id
    WHERE b.manhole_indicator = 1 AND c.id IS NOT NULL;
""",
    "sql_quality_pipe": """
----------------- Leidingen ------------------------
----------------------------------------------------
-- Beginpunt leiding is gelijk aan eindpunt
CREATE OR REPLACE VIEW {schema}.leiding_beginpunt_is_eindpunt AS
    SELECT
        pipe.code AS leiding,
        pipe.id AS threedi_id,
        start_node.code AS beginpunt,
        end_node.code AS eindpunt,
        start_node.id AS beginpunt_threedi_id,
        end_node.id AS eindpunt_threedi_id,
	    NULL::text AS status,
        start_node.the_geom::geometry(Point, 28992)
    FROM v2_pipe pipe
    LEFT JOIN v2_connection_nodes start_node
        ON 	pipe.connection_node_start_id = start_node.id 
    LEFT JOIN v2_connection_nodes end_node
        ON 	pipe.connection_node_end_id = end_node.id
    WHERE start_node.id = end_node.id;
-- Materiaal ontbreekt
CREATE OR REPLACE VIEW {schema}.leiding_materiaal_onlogisch AS
    SELECT
        pipe.code AS leiding,
        pipe.id AS threedi_id,
        start_node.code AS beginpunt,
        end_node.code AS eindpunt,
        'materiaal type onlogisch'::text AS bericht,
	    NULL::text AS status,
        st_makeline(start_node.the_geom, end_node.the_geom)::geometry(Linestring, 28992) AS the_geom
    FROM v2_pipe pipe
    JOIN v2_connection_nodes start_node
        ON 	pipe.connection_node_start_id = start_node.id
    JOIN v2_connection_nodes end_node
        ON 	pipe.connection_node_end_id = end_node.id
    WHERE material > 8;
-- BOB's aanwezig
CREATE OR REPLACE VIEW {schema}.leiding_bob_onlogisch AS
    SELECT
        pipe.code AS leiding,
        pipe.id AS threedi_id,
        pipe.connection_node_start_id AS threedi_start_id,
        pipe.connection_node_end_id AS threedi_end_id,
        start_node.code AS beginpunt,
        end_node.code AS eindpunt,
        pipe.invert_level_start_point AS bob_beginpunt,
        pipe.invert_level_end_point AS bob_eindpunt,
        (array_greatest(string_to_array(height,' '))::float * 1000)::double precision AS hoogte_profiel,
        'bob beginpunt en/of eindpunt onlogsich'::text AS bericht,
	    NULL::text AS status,
        st_makeline(start_node.the_geom, end_node.the_geom)::geometry(Linestring, 28992) AS the_geom
    FROM v2_pipe pipe
    JOIN v2_connection_nodes start_node
        ON 	pipe.connection_node_start_id = start_node.id
    JOIN v2_connection_nodes end_node
        ON 	pipe.connection_node_end_id = end_node.id
    LEFT JOIN v2_cross_section_definition def
        ON pipe.cross_section_definition_id = def.id
    WHERE pipe.invert_level_start_point = 0
	OR pipe.invert_level_start_point < {min_levels}
	OR pipe.invert_level_start_point > {max_levels}
	OR pipe.invert_level_end_point = 0
	OR pipe.invert_level_end_point < {min_levels}
	OR pipe.invert_level_end_point > {max_levels};
-- Zeer korte leidingen (< x m)
CREATE OR REPLACE VIEW {schema}.leiding_kort AS
    SELECT
        pipe.code AS leiding,
        pipe.id AS threedi_id,
        start_node.code AS beginpunt,
        end_node.code AS eindpunt,
        ST_Length(st_makeline(start_node.the_geom, end_node.the_geom)) AS lengte_leiding,
	    NULL::text AS status,
        st_makeline(start_node.the_geom, end_node.the_geom)::geometry(Linestring, 28992) AS the_geom
    FROM v2_pipe pipe
    JOIN v2_connection_nodes start_node
        ON 	pipe.connection_node_start_id = start_node.id 
    JOIN v2_connection_nodes end_node
        ON 	pipe.connection_node_end_id = end_node.id
    WHERE (ST_Length(st_makeline(start_node.the_geom, end_node.the_geom)) < {min_length}) AND (start_node.id != end_node.id);
-- Zeer lange lange leidingen (> x m)
CREATE OR REPLACE VIEW {schema}.leiding_lang AS
    SELECT
        pipe.code AS leiding,
        pipe.id AS threedi_id,
        start_node.code AS beginpunt,
        end_node.code AS eindpunt,
        ST_Length(st_makeline(start_node.the_geom, end_node.the_geom)) AS lengte_leiding,
	    NULL::text AS status,
        st_makeline(start_node.the_geom, end_node.the_geom)::geometry(Linestring, 28992) AS the_geom
    FROM v2_pipe pipe
    JOIN v2_connection_nodes start_node
        ON 	pipe.connection_node_start_id = start_node.id 
    JOIN v2_connection_nodes end_node
        ON 	pipe.connection_node_end_id = end_node.id
    WHERE ST_Length(st_makeline(start_node.the_geom, end_node.the_geom)) > {max_length};
-- Dubbele leidingen
CREATE OR REPLACE VIEW {schema}.leiding_dubbel AS
    SELECT
        string_agg(line_id::text, ', ' ORDER BY line_type) AS threedi_ids,
        string_agg(start_point::text, ', ' ORDER BY line_type) AS beginpunt,
        string_agg(end_point::text, ', ' ORDER BY line_type) AS eindpunt,
        string_agg(display_name::text, ', ' ORDER BY line_type) AS leidingen,
        string_agg(line_type::text, ', ' ORDER BY line_type) AS type_leidingen,
        count(*) AS aantal_leidingen,
	    NULL::text AS status,
        the_geom::geometry(Linestring, 28992)
    FROM (
        SELECT
            pipe.id AS line_id,
            pipe.code AS display_name,
            'leiding' AS line_type,
            start_node.code AS start_point,
            end_node.code AS end_point,
            st_makeline(start_node.the_geom, end_node.the_geom)::geometry(Linestring, 28992) AS the_geom
        FROM v2_pipe pipe
        JOIN v2_connection_nodes start_node
            ON 	pipe.connection_node_start_id = start_node.id 
        JOIN v2_connection_nodes end_node
            ON 	pipe.connection_node_end_id = end_node.id
        UNION ALL
        SELECT
            weir.id AS line_id,
            weir.code AS display_name,
            'overstort' AS line_type,
            start_node.code AS start_point,
            end_node.code AS end_point,
            st_makeline(start_node.the_geom, end_node.the_geom)::geometry(Linestring, 28992) AS the_geom
        FROM v2_weir weir
        JOIN v2_connection_nodes start_node
            ON 	weir.connection_node_start_id = start_node.id 
        JOIN v2_connection_nodes end_node
            ON 	weir.connection_node_end_id = end_node.id
        UNION ALL
        SELECT
            orf.id AS line_id,
            orf.code AS display_name,
            'doorlaat' AS line_type,
            start_node.code AS start_point,
            end_node.code AS end_point,
            st_makeline(start_node.the_geom, end_node.the_geom)::geometry(Linestring, 28992) AS the_geom
        FROM v2_orifice orf
        JOIN v2_connection_nodes start_node
            ON 	orf.connection_node_start_id = start_node.id 
        JOIN v2_connection_nodes end_node
            ON 	orf.connection_node_end_id = end_node.id
    ) AS a
    GROUP BY the_geom
    HAVING count(*) > 1;
-- Verbindingen tussen Gemengd/RWA/DWA
CREATE OR REPLACE VIEW {schema}.leiding_verkeerde_types_verbonden AS
    WITH nodes AS (
        SELECT
            point AS geom,
            CASE
                WHEN sewerage_type = 0 THEN 'gemengd'
                WHEN sewerage_type = 1 THEN 'rwa'
                WHEN sewerage_type = 2 THEN 'dwa'
                WHEN sewerage_type = 3 THEN 'transport'
                WHEN sewerage_type = 7 THEN 'bergbezink'
                WHEN sewerage_type >= 10 THEN 'overige'
            END AS sewerage_type
        FROM (
            SELECT
                start_pipe.the_geom::geometry(Point, 28992) AS point,
                sewerage_type
            FROM v2_pipe pipe JOIN v2_connection_nodes start_pipe ON pipe.connection_node_start_id = start_pipe.id 
            UNION ALL
            SELECT
                end_pipe.the_geom::geometry(Point, 28992) AS point,
                sewerage_type
            FROM v2_pipe pipe JOIN v2_connection_nodes end_pipe ON pipe.connection_node_end_id = end_pipe.id 
        ) AS a
    GROUP BY point, sewerage_type
    ),
    count_nodes_pipe_typologies AS (
        SELECT
            count(*) AS pipe_typologies,
            string_agg(sewerage_type::Text, ', ' ORDER BY sewerage_type) AS typologies,
            geom::geometry(Point, 28992) AS the_geom
        FROM nodes
        GROUP BY geom)
    SELECT DISTINCT ON (the_geom)
        c.code AS rioolput,
        c.id AS threedi_id,
        typologies AS type_inzameling,
        CASE
            WHEN manhole_indicator = 0 THEN 'inspectieput'
            WHEN manhole_indicator = 1 THEN 'uitlaat'
            WHEN manhole_indicator = 2 THEN 'pomp'
            WHEN manhole_indicator = 4 THEN 'overstort'
            WHEN manhole_indicator IS NULL THEN NULL
            ELSE 'overige'
 		END as type_knooppunt,
	    NULL::text AS status,
        a.the_geom::geometry(Point, 28992)
    FROM
        v2_connection_nodes AS a JOIN v2_manhole c ON a.id = c.connection_node_id,
        count_nodes_pipe_typologies AS b
    WHERE pipe_typologies > 1 AND a.the_geom && b.the_geom;
-- Leidingen met verhang groter dan opgegeven waarde
CREATE OR REPLACE VIEW {schema}.leiding_groot_verhang AS
    SELECT
        pipe.code AS leiding,
        pipe.id AS threedi_id,
        start_node.code AS beginpunt,
        end_node.code AS eindpunt,
        invert_level_start_point AS bob_beginpunt,
        invert_level_end_point AS bob_eindpunt,
        (invert_level_start_point - invert_level_end_point) AS hoogte_verschil_bob,
        ST_Length(st_makeline(start_node.the_geom, end_node.the_geom)) AS lengte_leiding,
        ST_Length(st_makeline(start_node.the_geom, end_node.the_geom))/abs(invert_level_start_point - invert_level_end_point) AS verhang,
	    NULL::text AS status,
        st_makeline(start_node.the_geom, end_node.the_geom)::geometry(Linestring, 28992) AS the_geom
    FROM v2_pipe pipe
    JOIN v2_connection_nodes start_node
        ON 	pipe.connection_node_start_id = start_node.id 
    JOIN v2_connection_nodes end_node
        ON 	pipe.connection_node_end_id = end_node.id
    WHERE invert_level_start_point != invert_level_end_point
        AND (ST_Length(st_makeline(start_node.the_geom, end_node.the_geom))/abs(invert_level_start_point - invert_level_end_point)) < {max_verhang};
-- Dekking minder dan een bepaalde dekking voor start_node
CREATE OR REPLACE VIEW {schema}.leiding_dekking_start AS
    SELECT
        pipe.code AS leiding,
        pipe.id AS threedi_id,
        manh.code AS beginpunt,
        invert_level_start_point AS bob_beginpunt,
		( CASE
            WHEN def.shape = 2 THEN def.width::double precision
			WHEN def.shape = 3 THEN def.height::double precision
			WHEN def.shape > 4 THEN array_greatest(string_to_array(def.height,' '))::double precision
			ELSE 0
			END
		) AS hoogte_profiel,
		round((invert_level_start_point +
		( CASE
            WHEN def.shape = 2 THEN def.width::double precision
			WHEN def.shape = 3 THEN def.height::double precision
			WHEN def.shape > 4 THEN array_greatest(string_to_array(def.height,' '))::double precision
			ELSE 0
			END
		))::numeric,3) AS bovenkant_leiding,
        round(surface_level::numeric,3) AS put_maaiveldhoogte,
        maaiveld AS ahn_maaiveldhoogte,
        round((surface_level - invert_level_start_point -
        ( CASE
            WHEN def.shape = 2 THEN def.width::double precision
			WHEN def.shape = 3 THEN def.height::double precision
			WHEN def.shape > 4 THEN array_greatest(string_to_array(def.height,' '))::double precision
			ELSE 0
			END
		))::numeric,3) AS dekking_put_maaiveldhoogte,
        round((maaiveld - invert_level_start_point -
		( CASE
            WHEN def.shape = 2 THEN def.width::double precision
			WHEN def.shape = 3 THEN def.height::double precision
			WHEN def.shape > 4 THEN array_greatest(string_to_array(def.height,' '))::double precision
			ELSE 0
			END
		))::numeric,3) AS dekking_ahn_maaiveldhoogte,
	    NULL::text AS status,
        st_makeline(start_node.the_geom, end_node.the_geom)::geometry(Linestring, 28992) AS the_geom
    FROM v2_pipe pipe
    JOIN v2_connection_nodes start_node
        ON 	pipe.connection_node_start_id = start_node.id 
    JOIN v2_connection_nodes end_node
        ON 	pipe.connection_node_end_id = end_node.id 
    LEFT JOIN v2_cross_section_definition def
        ON pipe.cross_section_definition_id = def.id,
    src.manhole_maaiveld ahn JOIN v2_manhole manh ON manh.id = ahn.manh_id
    WHERE
        round((surface_level - invert_level_start_point -
        ( CASE
            WHEN def.shape = 2 THEN def.width::double precision
			WHEN def.shape = 3 THEN def.height::double precision
			WHEN def.shape > 4 THEN array_greatest(string_to_array(def.height,' '))::double precision
			ELSE 0
			END
		))::numeric,3) < {min_dekking}
        AND ahn.manh_id = pipe.connection_node_start_id
        AND pipe.invert_level_start_point IS NOT NULL
        AND manh.surface_level IS NOT NULL;
-- Dekking minder dan een bepaalde dekking voor end_node
CREATE OR REPLACE VIEW {schema}.leiding_dekking_eind AS
    SELECT
        pipe.code AS leiding,
        pipe.id AS threedi_id,
        manh.code AS beginpunt,
        invert_level_end_point AS bob_eindpunt,
		( CASE
            WHEN def.shape = 2 THEN def.width::double precision
			WHEN def.shape = 3 THEN def.height::double precision
			WHEN def.shape > 4 THEN array_greatest(string_to_array(def.height,' '))::double precision
			ELSE 0
			END
		) AS hoogte_profiel,
		round((invert_level_end_point +
		(	CASE
            WHEN def.shape = 2 THEN def.width::double precision
			WHEN def.shape = 3 THEN def.height::double precision
			WHEN def.shape > 4 THEN array_greatest(string_to_array(def.height,' '))::double precision
			ELSE 0
			END
		))::numeric,3) AS bovenkant_leiding,
        round(surface_level::numeric,3) AS put_maaiveldhoogte,
        maaiveld AS ahn_maaiveldhoogte,
        round((surface_level - invert_level_end_point -
        ( CASE
            WHEN def.shape = 2 THEN def.width::double precision
			WHEN def.shape = 3 THEN def.height::double precision
			WHEN def.shape > 4 THEN array_greatest(string_to_array(def.height,' '))::double precision
			ELSE 0
			END
		))::numeric,3) AS dekking_put_maaiveldhoogte,
        round((maaiveld - invert_level_end_point -
		( CASE
            WHEN def.shape = 2 THEN def.width::double precision
			WHEN def.shape = 3 THEN def.height::double precision
			WHEN def.shape > 4 THEN array_greatest(string_to_array(def.height,' '))::double precision
			ELSE 0
			END
		))::numeric,3) AS dekking_ahn_maaiveldhoogte,
	NULL::text AS status,
        st_makeline(start_node.the_geom, end_node.the_geom)::geometry(Linestring, 28992) AS the_geom
    FROM v2_pipe pipe
    JOIN v2_connection_nodes start_node
        ON 	pipe.connection_node_start_id = start_node.id 
    JOIN v2_connection_nodes end_node
        ON 	pipe.connection_node_end_id = end_node.id 
    LEFT JOIN v2_cross_section_definition def
        ON pipe.cross_section_definition_id = def.id,
    src.manhole_maaiveld ahn JOIN v2_manhole manh ON manh.id = ahn.manh_id
    WHERE
        round((surface_level - invert_level_end_point -
        ( CASE
            WHEN def.shape = 2 THEN def.width::double precision
			WHEN def.shape = 3 THEN def.height::double precision
			WHEN def.shape > 4 THEN array_greatest(string_to_array(def.height,' '))::double precision
			ELSE 0
			END
		))::numeric,3) < {min_dekking}
        AND ahn.manh_id = pipe.connection_node_end_id
        AND pipe.invert_level_end_point IS NOT NULL
        AND manh.surface_level IS NOT NULL;
-- Dwarsdoorsnede logisch
CREATE OR REPLACE VIEW {schema}.leiding_doorsnede_onlogisch AS
    with xsecs as (
        SELECT
            id,
            shape,
            array_greatest(string_to_array(width,' '))::float as width,
			width as width_original,
            array_greatest(string_to_array(height,' '))::float as height,
			height as height_original,
            code
        from v2_cross_section_definition
    )
    SELECT
        pipe.code AS leiding,
        pipe.id AS threedi_id,
        start_node.code AS beginpunt,
        end_node.code AS eindpunt,
        CASE
            WHEN shape = 1 THEN 'rechthoekig (open)'
            WHEN shape = 2 THEN 'rond'
            WHEN shape = 3 THEN 'eivormig'
            WHEN shape = 5 THEN 'rechthoekig (getabelleerd)'
            WHEN shape = 6 THEN 'getabelleerd trapezium'
            WHEN shape IS NULL THEN NULL
            ELSE 'overige'
 		END as vormprofiel,
        width * 1000 AS breedte,
        height * 1000 AS hoogte,
        CASE
            WHEN width = 0 AND shape < 5 THEN 'breedte is nul'
            WHEN height = 0 AND shape < 5 THEN 'hoogte is nul'
            WHEN width != height AND height IS NOT NULL AND shape = 2 THEN 'breedte ongelijk aan hoogte in ronde buis'
            WHEN round(1.5*width::numeric,4) != round(height::numeric,4) AND shape = 3 THEN 'afmetingen in ei-buis onlogisch'
            WHEN height IS NULL AND (shape = 5 OR shape = 6) THEN 'getabelleerde hoogte ontbreekt'
            WHEN (NOT width_original LIKE '% %' OR NOT height_original LIKE '% %') AND (shape = 5 OR shape = 6) THEN 'parameters ontbreken in getabelleerde vorm'
            WHEN width < {min_dimensions} THEN 'breedte is zeer klein'
            WHEN height < {min_dimensions} THEN 'hoogte is zeer klein'
            WHEN width > {max_dimensions} THEN 'breedte is zeer groot'
            WHEN height > {max_dimensions} THEN 'hoogte is zeer groot'
            ELSE NULL
        END AS bericht,
	    NULL::text AS status,
        st_makeline(start_node.the_geom, end_node.the_geom)::geometry(Linestring, 28992) AS the_geom
    --SELECT DISTINCT shape, width, height, def.code 
	FROM v2_pipe pipe
    JOIN v2_connection_nodes start_node
        ON 	pipe.connection_node_start_id = start_node.id 
    JOIN v2_connection_nodes end_node
        ON 	pipe.connection_node_end_id = end_node.id 
    LEFT JOIN xsecs def
        ON pipe.cross_section_definition_id = def.id
    WHERE (width = 0 AND shape < 5)
        OR (height = 0 AND shape < 5)
        OR (width != height AND height IS NOT NULL AND shape = 2)
        OR (round(1.5*width::numeric,4) != round(height::numeric,4) AND shape = 3)
        OR (height IS NULL AND (shape = 5 OR shape = 6))
        OR ((NOT width_original LIKE '% %' OR NOT height_original LIKE '% %') AND shape > 4)
        OR width < {min_dimensions}
        OR height < {min_dimensions}
    	OR width > {max_dimensions}
    	OR height > {max_dimensions};
""",
    "sql_quality_weir": """
----------------- Overstorten ----------------------
----------------------------------------------------
-- Drempelhoogte logisch
CREATE OR REPLACE VIEW {schema}.overstort_niveau_onlogisch AS
    SELECT
        weir.code AS overstort,
        weir.id AS threedi_id,
        start_node.code AS beginpunt,
        end_node.code AS eindpunt,
        weir.crest_level AS drempelniveau,
        CASE
            WHEN weir.crest_level = 0 THEN 'drempelniveau is nul'::text
            WHEN weir.crest_level < {min_levels} THEN 'drempelniveau is zeer laag'::text
            WHEN weir.crest_level > {max_levels} THEN 'drempelniveau is zeer hoog'::text
            ELSE NULL
        END AS bericht,
	    NULL::text AS status,
        st_makeline(start_node.the_geom, end_node.the_geom)::geometry(Linestring, 28992) AS the_geom
    FROM v2_weir weir
    JOIN v2_connection_nodes start_node
        ON 	weir.connection_node_start_id = start_node.id 
    JOIN v2_connection_nodes end_node
        ON 	weir.connection_node_end_id = end_node.id 
    LEFT JOIN v2_cross_section_definition def
        ON weir.cross_section_definition_id = def.id
    WHERE weir.crest_level = 0
	OR weir.crest_level < {min_levels}
	OR weir.crest_level > {max_levels};
-- Vrije overstorthoogte; drempelhoogte boven maaiveld
CREATE OR REPLACE VIEW {schema}.overstort_drempel_boven_maaiveld AS
    SELECT
        weir.code AS overstort,
        weir.id AS threedi_id,
        start_node.code AS beginpunt,
        end_node.code AS eindpunt,
        crest_level AS drempelniveau,
        CASE
            WHEN weir.connection_node_start_id = ahn.manh_id THEN 'begin_overstort'
            WHEN weir.connection_node_end_id = ahn.manh_id THEN 'eind_overstort'
        END AS locatie,
        CASE
            WHEN (weir.crest_level > manh.surface_level AND weir.crest_level > maaiveld) THEN 'boven ahn en put maaiveld'
            WHEN weir.crest_level > manh.surface_level THEN 'boven put maaiveld'
            WHEN weir.crest_level > ahn.maaiveld THEN 'boven ahn maaiveld'
        END AS maaiveld_check,
	    NULL::text AS status,
        st_makeline(start_node.the_geom, end_node.the_geom)::geometry(Linestring, 28992) AS the_geom
    FROM v2_weir weir
    JOIN v2_connection_nodes start_node
        ON 	weir.connection_node_start_id = start_node.id
    JOIN v2_connection_nodes end_node
        ON 	weir.connection_node_end_id = end_node.id
    LEFT JOIN src.manhole_maaiveld ahn
        ON (weir.connection_node_start_id = ahn.manh_id OR weir.connection_node_end_id = ahn.manh_id)
    LEFT JOIN v2_manhole manh
        ON ahn.manh_id = manh.connection_node_id
    WHERE weir.crest_level > manh.surface_level OR (weir.crest_level > ahn.maaiveld AND round((ahn.maaiveld - manh.surface_level)::numeric,2) > {hoogte_verschil}) AND manhole_indicator != 1
    ORDER BY locatie DESC;
-- Overstorthoogte < putbodem
CREATE OR REPLACE VIEW {schema}.overstort_drempel_onder_putbodem AS
    SELECT
        weir.code AS overstort,
        weir.id AS threedi_id,
        start_node.code AS beginpunt,
        crest_level AS drempelniveau,
        manh.bottom_level AS bodemhoogte,
	    NULL::text AS status,
        st_makeline(start_node.the_geom, end_node.the_geom)::geometry(Linestring, 28992) AS the_geom
    FROM v2_weir weir
    JOIN v2_connection_nodes start_node
        ON 	weir.connection_node_start_id = start_node.id
    JOIN v2_connection_nodes end_node
        ON 	weir.connection_node_end_id = end_node.id
    LEFT JOIN v2_manhole manh
        ON 	manh.connection_node_id = start_node.id
    WHERE weir.crest_level < manh.bottom_level;
-- overstort lengte
CREATE OR REPLACE VIEW {schema}.overstort_korte_lengte AS
    SELECT
        weir.code AS overstort,
        weir.id AS threedi_id,
        start_node.code AS beginpunt,
        end_node.code AS eindpunt,
        ST_Length(st_makeline(start_node.the_geom, end_node.the_geom)) AS lengte_overstort,
	    NULL::text AS status,
        st_makeline(start_node.the_geom, end_node.the_geom)::geometry(Linestring, 28992) AS the_geom
    FROM v2_weir weir
    JOIN v2_connection_nodes start_node
        ON 	weir.connection_node_start_id = start_node.id
    JOIN v2_connection_nodes end_node
        ON 	weir.connection_node_end_id = end_node.id
    WHERE ST_Length(st_makeline(start_node.the_geom, end_node.the_geom)) < {min_length};
-- Dwarsdoorsnede logisch
CREATE OR REPLACE VIEW {schema}.overstort_doorsnede_onlogisch AS
    SELECT
        weir.code AS leiding,
        weir.id AS threedi_id,
        start_node.code AS beginpunt,
        end_node.code AS eindpunt,
        CASE
            WHEN shape = 1 THEN 'rechthoekig (open)'
            WHEN shape = 2 THEN 'rond'
            WHEN shape = 3 THEN 'eivormig'
            WHEN shape = 5 THEN 'rechthoekig (getabelleerd)'
            WHEN shape = 6 THEN 'getabelleerd trapezium'
            WHEN shape IS NULL THEN NULL
            ELSE 'overige'
	END as vormprofiel,
        (array_greatest(string_to_array(width,' '))::float * 1000)::double precision AS breedte,
        (array_greatest(string_to_array(height,' '))::float * 1000)::double precision AS hoogte,
        CASE
            WHEN width::double precision = 0 AND shape < 5 THEN 'breedte is nul'
            WHEN height::double precision = 0 AND shape < 5 THEN 'hoogte is nul'
            WHEN width != height AND height IS NOT NULL AND shape = 2 THEN 'breedte ongelijk aan hoogte in ronde buis'
            WHEN round(1.5*width::numeric,4) != round(height::numeric,4) AND shape = 3 THEN 'afmetingen in ei-buis onlogisch'
            WHEN height IS NULL AND (shape = 5 OR shape = 6) THEN 'getabelleerde hoogte ontbreekt'
            WHEN (NOT width LIKE '% %' OR NOT height LIKE '% %') AND (shape = 5 OR shape = 6) THEN 'parameters ontbreken in getabelleerde vorm'
            WHEN (width::float < {min_dimensions}::float AND shape < 5) OR (array_greatest(string_to_array(width,' '))::float < {min_dimensions}::float AND shape > 4) THEN 'breedte is zeer klein'
            WHEN (height::float < {min_dimensions}::float AND shape < 5) OR (array_greatest(string_to_array(height,' '))::float < {min_dimensions}::float AND shape > 4) THEN 'hoogte is zeer klein'
            WHEN (width::float < {max_dimensions}::float AND shape < 5) OR (array_greatest(string_to_array(width,' '))::float < {max_dimensions}::float AND shape > 4) THEN 'breedte is zeer groot'
            WHEN (height::float < {max_dimensions}::float AND shape < 5) OR (array_greatest(string_to_array(height,' '))::float < {max_dimensions}::float AND shape > 4) THEN 'hoogte is zeer groot'
            ELSE NULL
        END AS bericht,
	    NULL::text AS status,
        st_makeline(start_node.the_geom, end_node.the_geom)::geometry(Linestring, 28992) AS the_geom
    FROM v2_weir weir
    JOIN v2_connection_nodes start_node
        ON 	weir.connection_node_start_id = start_node.id 
    JOIN v2_connection_nodes end_node
        ON 	weir.connection_node_end_id = end_node.id 
    LEFT JOIN v2_cross_section_definition def
        ON weir.cross_section_definition_id = def.id
    WHERE (width::double precision = 0 AND shape < 5)
        OR (height::double precision = 0 AND shape < 5)
        OR (width != height AND height IS NOT NULL AND shape = 2)
        OR (round(1.5*width::numeric,4) != round(height::numeric,4) AND shape = 3)
        OR (height IS NULL AND (shape = 5 OR shape = 6))
        OR ((NOT width LIKE '% %' OR NOT height LIKE '% %') AND shape > 4)
	OR (width::float < {min_dimensions}::float AND shape < 5)
	OR (array_greatest(string_to_array(width,' '))::float < {min_dimensions}::float AND shape > 4)
	OR (height::float < {min_dimensions}::float AND shape < 5)
	OR (array_greatest(string_to_array(height,' '))::float < {min_dimensions}::float AND shape > 4)
    	OR (width::float < {max_dimensions}::float AND shape < 5)
    	OR (array_greatest(string_to_array(width,' '))::float < {max_dimensions}::float AND shape > 4)
    	OR (height::float < {max_dimensions}::float AND shape < 5)
    	OR (array_greatest(string_to_array(height,' '))::float < {max_dimensions}::float AND shape > 4);
""",
    "sql_quality_orifice": """
------------------- Doorlaten ----------------------
----------------------------------------------------
-- Openingshoogte logisch
CREATE OR REPLACE VIEW {schema}.doorlaat_niveau_onlogisch AS
    SELECT
        orf.code AS doorlaat,
        orf.id AS threedi_id,
        start_node.code AS beginpunt,
        end_node.code AS eindpunt,
        orf.crest_level AS doorlaatniveau,
        CASE
            WHEN orf.crest_level = 0 THEN 'doorlaatniveau is nul'::text
            WHEN orf.crest_level < {min_levels} THEN 'doorlaatniveau is zeer laag'::text
            WHEN orf.crest_level > {max_levels} THEN 'doorlaatniveau is zeer hoog'::text
            ELSE NULL
        END AS bericht,
	    NULL::text AS status,
        st_makeline(start_node.the_geom, end_node.the_geom)::geometry(Linestring, 28992) AS the_geom
    FROM v2_orifice orf
    JOIN v2_connection_nodes start_node
        ON 	orf.connection_node_start_id = start_node.id 
    JOIN v2_connection_nodes end_node
        ON 	orf.connection_node_end_id = end_node.id 
    LEFT JOIN v2_cross_section_definition def
        ON orf.cross_section_definition_id = def.id
    WHERE orf.crest_level = 0
	OR orf.crest_level < {min_levels}
	OR orf.crest_level > {max_levels};
-- openingshoogte boven maaiveld
CREATE OR REPLACE VIEW {schema}.doorlaat_drempel_boven_maaiveld AS
    SELECT
        orf.code AS doorlaat,
        orf.id AS threedi_id,
        start_node.code AS beginpunt,
        end_node.code AS eindpunt,
        crest_level AS doorlaatniveau,
        CASE
            WHEN orf.connection_node_start_id = ahn.manh_id THEN 'begin_doorlaat'
            WHEN orf.connection_node_end_id = ahn.manh_id THEN 'eind_doorlaat'
        END AS locatie,
        CASE
            WHEN (orf.crest_level > manh.surface_level AND orf.crest_level > maaiveld) THEN 'boven ahn en put maaiveld'
            WHEN orf.crest_level > manh.surface_level THEN 'boven put maaiveld'
            WHEN orf.crest_level > ahn.maaiveld THEN 'boven ahn maaiveld'
        END AS maaiveld_check,
	    NULL::text AS status,
        st_makeline(start_node.the_geom, end_node.the_geom)::geometry(Linestring, 28992) AS the_geom
    FROM v2_orifice orf
    JOIN v2_connection_nodes start_node
        ON 	orf.connection_node_start_id = start_node.id
    JOIN v2_connection_nodes end_node
        ON 	orf.connection_node_end_id = end_node.id
    LEFT JOIN src.manhole_maaiveld ahn
        ON (orf.connection_node_start_id = ahn.manh_id OR orf.connection_node_end_id = ahn.manh_id)
    LEFT JOIN v2_manhole manh
        ON ahn.manh_id = manh.connection_node_id
    WHERE orf.crest_level > manh.surface_level OR (orf.crest_level > ahn.maaiveld AND round((ahn.maaiveld - manh.surface_level)::numeric,2) > {hoogte_verschil}) AND manhole_indicator != 1
    ORDER BY locatie DESC;
-- Openingshoogte < putbodem
CREATE OR REPLACE VIEW {schema}.doorlaat_drempel_onder_putbodem AS
    SELECT
        orf.code AS doorlaat,
        orf.id AS threedi_id,
        start_node.code AS beginpunt,
        crest_level AS doorlaatniveau,
        manh.bottom_level AS bodemhoogte,
	    NULL::text AS status,
        st_makeline(start_node.the_geom, end_node.the_geom)::geometry(Linestring, 28992) AS the_geom
    FROM v2_orifice orf
    JOIN v2_connection_nodes start_node
        ON 	orf.connection_node_start_id = start_node.id
    JOIN v2_connection_nodes end_node
        ON 	orf.connection_node_end_id = end_node.id
    LEFT JOIN v2_manhole manh
        ON 	(manh.connection_node_id = start_node.id OR manh.connection_node_id = end_node.id)
    WHERE orf.crest_level < manh.bottom_level;
-- doorlaat lengte
CREATE OR REPLACE VIEW {schema}.doorlaat_korte_lengte AS
    SELECT
        orf.code AS doorlaat,
        orf.id AS threedi_id,
        start_node.code AS beginpunt,
        end_node.code AS eindpunt,
        ST_Length(st_makeline(start_node.the_geom, end_node.the_geom)) AS lengte_overstort,
	    NULL::text AS status,
        st_makeline(start_node.the_geom, end_node.the_geom)::geometry(Linestring, 28992) AS the_geom
    FROM v2_orifice orf
    JOIN v2_connection_nodes start_node
        ON 	orf.connection_node_start_id = start_node.id
    JOIN v2_connection_nodes end_node
        ON 	orf.connection_node_end_id = end_node.id
    WHERE ST_Length(st_makeline(start_node.the_geom, end_node.the_geom)) < {min_length};
-- Dwarsdoorsnede logisch
CREATE OR REPLACE VIEW {schema}.doorlaat_doorsnede_onlogisch AS
    SELECT
        orf.code AS leiding,
        orf.id AS threedi_id,
        start_node.code AS beginpunt,
        end_node.code AS eindpunt,
        CASE
            WHEN shape = 1 THEN 'rechthoekig (open)'
            WHEN shape = 2 THEN 'rond'
            WHEN shape = 3 THEN 'eivormig'
            WHEN shape = 5 THEN 'rechthoekig (getabelleerd)'
            WHEN shape = 6 THEN 'getabelleerd trapezium'
            WHEN shape IS NULL THEN NULL
            ELSE 'overige'
	END as vormprofiel,
        (array_greatest(string_to_array(width,' '))::float * 1000)::double precision AS breedte,
        (array_greatest(string_to_array(height,' '))::float * 1000)::double precision AS hoogte,
        CASE
            WHEN width::double precision = 0 AND shape < 5 THEN 'breedte is nul'
            WHEN height::double precision = 0 AND shape < 5 THEN 'hoogte is nul'
            WHEN width != height AND height IS NOT NULL AND shape = 2 THEN 'breedte ongelijk aan hoogte in ronde buis'
            WHEN round(1.5*width::numeric,4) != round(height::numeric,4) AND shape = 3 THEN 'afmetingen in ei-buis onlogisch'
            WHEN height IS NULL AND (shape = 5 OR shape = 6) THEN 'getabelleerde hoogte ontbreekt'
            WHEN (NOT width LIKE '% %' OR NOT height LIKE '% %') AND (shape = 5 OR shape = 6) THEN 'parameters ontbreken in getabelleerde vorm'
            WHEN (width::float < {min_dimensions}::float AND shape < 5) OR (array_greatest(string_to_array(width,' '))::float < {min_dimensions}::float AND shape > 4) THEN 'breedte is zeer klein'
            WHEN (height::float < {min_dimensions}::float AND shape < 5) OR (array_greatest(string_to_array(height,' '))::float < {min_dimensions}::float AND shape > 4) THEN 'hoogte is zeer klein'
            WHEN (width::float < {max_dimensions}::float AND shape < 5) OR (array_greatest(string_to_array(width,' '))::float < {max_dimensions}::float AND shape > 4) THEN 'breedte is zeer groot'
            WHEN (height::float < {max_dimensions}::float AND shape < 5) OR (array_greatest(string_to_array(height,' '))::float < {max_dimensions}::float AND shape > 4) THEN 'hoogte is zeer groot'
            ELSE NULL
        END AS bericht,
	    NULL::text AS status,
        st_makeline(start_node.the_geom, end_node.the_geom)::geometry(Linestring, 28992) AS the_geom
    FROM v2_orifice orf
    JOIN v2_connection_nodes start_node
        ON 	orf.connection_node_start_id = start_node.id 
    JOIN v2_connection_nodes end_node
        ON 	orf.connection_node_end_id = end_node.id 
    LEFT JOIN v2_cross_section_definition def
        ON orf.cross_section_definition_id = def.id
    WHERE (width::double precision = 0 AND shape < 5)
        OR (height::double precision = 0 AND shape < 5)
        OR (width != height AND height IS NOT NULL AND shape = 2)
        OR (round(1.5*width::numeric,4) != round(height::numeric,4) AND shape = 3)
        OR (height IS NULL AND (shape = 5 OR shape = 6))
        OR ((NOT width LIKE '% %' OR NOT height LIKE '% %') AND shape > 4)
	OR (width::float < {min_dimensions}::float AND shape < 5)
	OR (array_greatest(string_to_array(width,' '))::float < {min_dimensions}::float AND shape > 4)
	OR (height::float < {min_dimensions}::float AND shape < 5)
	OR (array_greatest(string_to_array(height,' '))::float < {min_dimensions}::float AND shape > 4)
    	OR (width::float < {max_dimensions}::float AND shape < 5)
    	OR (array_greatest(string_to_array(width,' '))::float < {max_dimensions}::float AND shape > 4)
    	OR (height::float < {max_dimensions}::float AND shape < 5)
    	OR (array_greatest(string_to_array(height,' '))::float < {max_dimensions}::float AND shape > 4);
""",
    "sql_quality_pumpstation": """
------------------- Gemalen ------------------------
----------------------------------------------------
-- capaciteit 0 of negatief
CREATE OR REPLACE VIEW {schema}.pomp_capaciteit_onlogisch AS
    SELECT
        pump.code AS pomp,
        pump.id AS threedi_id,
        start_node.code AS beginpunt,
        end_node.code AS eindpunt,
        capacity AS pompcapaciteit,
        CASE
            WHEN capacity = 0 THEN 'pompcapaciteit = 0'::text
            WHEN capacity < 0 THEN 'pompcapaciteit is negatief'::text
            ELSE NULL
	    END AS bericht,
	    NULL::text AS status,
        start_node.the_geom::geometry(Point, 28992)
    FROM v2_pumpstation pump
    JOIN v2_connection_nodes start_node
        ON 	pump.connection_node_start_id = start_node.id 
    LEFT JOIN v2_connection_nodes end_node
        ON 	pump.connection_node_end_id = end_node.id
    WHERE capacity = 0 OR capacity < 0;
-- Aan- en afslagpeilen logisch
CREATE OR REPLACE VIEW {schema}.pomp_aan_afslagpeil_onlogisch AS
    SELECT
        pump.code AS pomp,
        pump.id AS threedi_id,
        start_node.code AS beginpunt,
        end_node.code AS eindpunt,
        CASE
            WHEN type = 1 THEN start_level
            WHEN type = 2 THEN NULL
            ELSE start_level
	    END AS aanslagniveau_bovenstrooms,
        CASE
            WHEN type = 1 THEN lower_stop_level
            WHEN type = 2 THEN NULL
            ELSE lower_stop_level
	    END AS afslagniveau_bovenstrooms,
        CASE
            WHEN type = 1 THEN NULL
            WHEN type = 2 THEN start_level
            ELSE NULL
	    END AS aanslagniveau_benedenstrooms,
        CASE
            WHEN type = 1 THEN NULL
            WHEN type = 2 THEN lower_stop_level
            ELSE NULL
	    END AS afslagniveau_benedenstrooms,
        CASE
            WHEN (start_level = 0 OR start_level < {min_levels} OR start_level > {max_levels})
                AND (lower_stop_level != 0 AND lower_stop_level > {min_levels} AND lower_stop_level < {max_levels})
            THEN 'aanslagniveau onlogisch'::text
            WHEN (start_level != 0 AND start_level > {min_levels} AND start_level < {max_levels})
                AND (lower_stop_level = 0 OR lower_stop_level < {min_levels} OR lower_stop_level > {max_levels})
            THEN 'afslagniveau onlogisch'::text
            WHEN (start_level = 0 OR start_level < {min_levels} OR start_level > {max_levels})
                AND (lower_stop_level = 0 OR lower_stop_level > {min_levels} OR lower_stop_level < {max_levels})
            THEN 'aan- en afslagniveau onlogisch'::text
            ELSE NULL
 		END AS bericht,
        upper_stop_level AS hoogafslagniveau,
        CASE
            WHEN upper_stop_level < {min_levels} THEN 'bijzonder laag'::text
            WHEN upper_stop_level > {max_levels} THEN 'bijzonder hoog'::text
            ELSE NULL
        END AS bericht_hoogafslagniveau,
	    NULL::text AS status,
        start_node.the_geom::geometry(Point, 28992)
    FROM v2_pumpstation pump
    JOIN v2_connection_nodes start_node
        ON 	pump.connection_node_start_id = start_node.id 
    LEFT JOIN v2_connection_nodes end_node
        ON 	pump.connection_node_end_id = end_node.id
    WHERE start_level = 0
        OR start_level < {min_levels}
        OR start_level > {max_levels}
        OR lower_stop_level = 0
        OR lower_stop_level < {min_levels}
        OR lower_stop_level > {max_levels}
        OR upper_stop_level < {min_levels}
        OR upper_stop_level > {max_levels};
-- Aanslagpeil > afslagpeil
CREATE OR REPLACE VIEW {schema}.pomp_aan_vs_afslagpeil AS
    SELECT
        pump.code AS pomp,
        pump.id AS threedi_id,
        start_node.code AS beginpunt,
        pump.start_level AS aanslagniveau_bovenstrooms,
        pump.lower_stop_level AS afslagniveau_bovenstrooms,
	    NULL::text AS status,
        start_node.the_geom::geometry(Point, 28992)
    FROM v2_pumpstation pump
    JOIN v2_connection_nodes start_node
        ON 	pump.connection_node_start_id = start_node.id 
    LEFT JOIN v2_connection_nodes end_node
        ON 	pump.connection_node_end_id = end_node.id
    WHERE start_level < lower_stop_level AND pump.type = 1;
-- Afslagpeil < bok => pomp slaat nooit af
CREATE OR REPLACE VIEW {schema}.pomp_afslagpeil_vs_bodemkelder AS
    SELECT
        pump.code AS pomp,
        pump.id AS threedi_id,
        start_node.code AS beginpunt,
        manh.bottom_level AS bodemhoogte,
        pump.start_level AS aanslagniveau_bovenstrooms,
        pump.lower_stop_level AS afslagniveau_bovenstrooms,
	    NULL::text AS status,
        start_node.the_geom::geometry(Point, 28992)
    FROM v2_pumpstation pump
    JOIN v2_connection_nodes start_node
        ON 	pump.connection_node_start_id = start_node.id 
    LEFT JOIN v2_connection_nodes end_node
        ON 	pump.connection_node_end_id = end_node.id
    LEFT JOIN v2_manhole manh
        ON start_node.id = manh.connection_node_id
    WHERE lower_stop_level < manh.bottom_level AND pump.type = 1;
-- Aanslagpeil > maaiveld
CREATE OR REPLACE VIEW {schema}.pomp_aanslagpeil_vs_maaiveld AS
    SELECT
        pump.code AS pomp,
        pump.id AS threedi_id,
        start_node.code AS beginpunt,
        round(surface_level::numeric,3) AS put_maaiveldhoogte,
        maaiveld AS ahn_maaiveldhoogte,
        pump.start_level AS aanslagniveau_bovenstrooms,
        pump.lower_stop_level AS afslagniveau_bovenstrooms,
	    NULL::text AS status,
        start_node.the_geom::geometry(Point, 28992)
    FROM v2_pumpstation pump
    JOIN v2_connection_nodes start_node
        ON 	pump.connection_node_start_id = start_node.id 
    LEFT JOIN v2_connection_nodes end_node
        ON 	pump.connection_node_end_id = end_node.id
    LEFT JOIN v2_manhole manh
        ON start_node.id = manh.connection_node_id
    LEFT JOIN src.manhole_maaiveld ahn ON manh.id = ahn.manh_id
    WHERE (start_level > maaiveld OR start_level > surface_level) AND pump.type = 1;
""",
}
