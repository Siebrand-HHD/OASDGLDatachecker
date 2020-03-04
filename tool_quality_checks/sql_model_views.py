# -*- coding: utf-8 -*-
# TODO aanlegjaar toevoegen        year AS begindatum,
# TODO putmateriaal toevoegen      material AS materiaalput,

sql_understandable_model_views = {
    "put": """CREATE OR REPLACE VIEW {schema}.put AS
    SELECT
        a.code AS rioolput,
        a.id AS threedi_id,
        CASE
            WHEN shape = '00' or shape = '02' THEN 'rechthoekig'
            WHEN shape = '01' THEN 'rond'
            ELSE 'overige'
 		END as vormput,
        width AS breedteput,
        length AS lengteput,
        CASE
            WHEN manhole_indicator = 0 THEN 'inspectieput'
            WHEN manhole_indicator = 1 THEN 'uitlaat'
            WHEN manhole_indicator = 2 THEN 'pomp'
            ELSE 'overige'
 		END as typeknooppunt,
        bottom_level AS z_coordinaat,
        surface_level AS maaiveldhoogte,
        b.the_geom
    FROM v2_manhole a JOIN v2_connection_nodes b ON a.connection_node_id = b.id;""",
    "leiding": """CREATE OR REPLACE VIEW {schema}.leiding AS
    SELECT
        pipe.code AS leiding,
        pipe.id AS threedi_id,
        start_node.code AS beginpuntleiding,
        end_node.code AS eindpuntleiding,
        CASE
            WHEN sewerage_type = 0 THEN 'gemengd_afvalwater'
            WHEN sewerage_type = 1 THEN 'afvloeiend_hemelwater'
            WHEN sewerage_type = 2 THEN 'droogweerafvoer'
            ELSE NULL
 		END as typeinzameling,
        invert_level_start_point AS bobbeginpuntleiding,
        invert_level_end_point AS bobeindpuntleiding,
        CASE
            WHEN material = 0 THEN 'beton'
            WHEN material = 1 THEN 'pvc'
            WHEN material = 2 THEN 'gres'
            WHEN material = 3 THEN 'gietijzer'
            WHEN material = 4 THEN 'metselwerk'
            WHEN material = 5 THEN 'polyetheen'
            WHEN material = 6 THEN 'hdpe'
            WHEN material = 7 THEN 'plaatijzer'
            WHEN material = 8 THEN 'staal'
            ELSE 'overige'
 		END as materiaalleiding,
        CASE
            WHEN shape = 1 THEN 'rechthoekig'
            WHEN shape = 2 THEN 'rond'
            WHEN shape = 3 THEN 'eivormig'
            WHEN shape = 5 THEN 'tabulated'
            WHEN shape = 6 THEN 'trapezium'
            ELSE 'overige'
 		END as vormprofiel,
        width AS breedteleiding,
        height AS hoogteleiding,
        st_makeline(start_node.the_geom, end_node.the_geom) AS the_geom
    FROM v2_pipe pipe
    LEFT JOIN v2_connection_nodes start_node
        ON 	pipe.connection_node_start_id = start_node.id 
    LEFT JOIN v2_connection_nodes end_node
        ON 	pipe.connection_node_end_id = end_node.id 
    LEFT JOIN v2_cross_section_definition def
        ON pipe.cross_section_definition_id = def.id;""",
    "overstort": """CREATE OR REPLACE VIEW {schema}.overstort AS
    SELECT
        weir.code AS overstort,
        weir.id AS threedi_id,
        start_node.code AS beginpuntoverstort,
        end_node.code AS eindpuntoverstort,
        CASE
            WHEN discharge_coefficient_positive = 0 AND discharge_coefficient_negative != 0 THEN 'stroming van eindpunt naar beginpunt'
            WHEN discharge_coefficient_negative = 0 AND discharge_coefficient_positive != 0 THEN 'stroming van beginpunt naar eindpunt'
            WHEN discharge_coefficient_positive != 0 AND discharge_coefficient_negative != 0 THEN 'stroming in beide richtingen'
            WHEN discharge_coefficient_positive = 0 AND discharge_coefficient_negative = 0 THEN 'geen stroming'
            ELSE NULL
        END AS stromingsrichting,
        CASE
            WHEN discharge_coefficient_positive > discharge_coefficient_negative THEN discharge_coefficient_positive
            WHEN discharge_coefficient_positive < discharge_coefficient_negative THEN discharge_coefficient_negative
            WHEN discharge_coefficient_positive = discharge_coefficient_negative THEN discharge_coefficient_positive
            ELSE NULL
        END AS afvoercoefficient,
        crest_level AS drempelniveau,
        width AS drempelbreedte,
        height AS vrijeoverstorthoogte,
        st_makeline(start_node.the_geom, end_node.the_geom) AS the_geom
    FROM v2_weir weir
    LEFT JOIN v2_connection_nodes start_node
        ON 	weir.connection_node_start_id = start_node.id 
    LEFT JOIN v2_connection_nodes end_node
        ON 	weir.connection_node_end_id = end_node.id 
    LEFT JOIN v2_cross_section_definition def
        ON weir.cross_section_definition_id = def.id;""",
    "doorlaat": """CREATE OR REPLACE VIEW {schema}.doorlaat AS
    SELECT
        orf.code AS doorlaat,
        orf.id AS threedi_id,
        start_node.code AS beginpuntdoorlaat,
        end_node.code AS eindpuntdoorlaat,
        CASE
            WHEN discharge_coefficient_positive = 0 AND discharge_coefficient_negative != 0 THEN 'stroming van eindpunt naar beginpunt'
            WHEN discharge_coefficient_negative = 0 AND discharge_coefficient_positive != 0 THEN 'stroming van beginpunt naar eindpunt'
            WHEN discharge_coefficient_positive != 0 AND discharge_coefficient_negative != 0 THEN 'stroming in beide richtingen'
            WHEN discharge_coefficient_positive = 0 AND discharge_coefficient_negative = 0 THEN 'geen stroming'
            ELSE NULL
        END AS stromingsrichting,
        CASE
            WHEN discharge_coefficient_positive > discharge_coefficient_negative THEN discharge_coefficient_positive
            WHEN discharge_coefficient_positive < discharge_coefficient_negative THEN discharge_coefficient_negative
            WHEN discharge_coefficient_positive = discharge_coefficient_negative THEN discharge_coefficient_positive
            ELSE NULL
        END AS contractiecoefficient_doorlaatprofiel,
        -- max_capacity AS maximalecapaciteitdoorlaat,
        discharge_coefficient_positive AS contractiecoefficientdoorlaatprofiel,
        crest_level AS doorlaatniveau,
        CASE
            WHEN shape = 1 THEN 'rechthoekig'
            WHEN shape = 2 THEN 'rond'
            WHEN shape = 3 THEN 'eivormig'
            WHEN shape = 5 THEN 'tabulated'
            WHEN shape = 6 THEN 'trapezium'
            ELSE 'overige'
 		END AS vormprofiel,
        width AS breedteleiding,
        height AS hoogteleiding,
        st_makeline(start_node.the_geom, end_node.the_geom) AS the_geom
    FROM v2_orifice orf
    LEFT JOIN v2_connection_nodes start_node
        ON 	orf.connection_node_start_id = start_node.id 
    LEFT JOIN v2_connection_nodes end_node
        ON 	orf.connection_node_end_id = end_node.id 
    LEFT JOIN v2_cross_section_definition def
        ON orf.cross_section_definition_id = def.id;""",
    "pomp": """CREATE OR REPLACE VIEW {schema}.pomp AS
    SELECT
        pump.code AS pomp,
        pump.id AS threedi_id,
        start_node.code AS beginpuntpomp,
        end_node.code AS eindpuntpomp,
        capacity AS pompcapaciteit,
        CASE
            WHEN type = 1 THEN start_level
            WHEN type = 2 THEN NULL
            ELSE NULL
 		END AS aanslagniveaubovenstrooms,
        CASE
            WHEN type = 1 THEN lower_stop_level
            WHEN type = 2 THEN NULL
            ELSE NULL
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
        st_makeline(start_node.the_geom, end_node.the_geom) AS the_geom
    FROM v2_pumpstation pump
    LEFT JOIN v2_connection_nodes start_node
        ON 	pump.connection_node_start_id = start_node.id 
    LEFT JOIN v2_connection_nodes end_node
        ON 	pump.connection_node_end_id = end_node.id;""",
}