# -*- coding: utf-8 -*-
# TODO begin- en eindputcode is niet beschikbaar voor putten en kunstwerken
# TODO aanlegjaar toevoegen        manh_year AS begindatum,
# TODO putmateriaal toevoegen      manh_material AS materiaalput,

dc_input = {
    "put": """CREATE OR REPLACE VIEW {schema}.put AS
    SELECT
        manh_code AS rioolput,
        CASE
 		WHEN manh_shape = '00' or manh_shape = '02' THEN 'rechthoekig'
 		WHEN manh_shape = '01' THEN 'rond'
 		END as vormput,
        manh_width AS breedteput,
        manh_length AS lengteput,
        CASE
 		WHEN manh_manhole_indicator = 0 THEN 'inspectieput'
 		WHEN manh_manhole_indicator = 1 THEN 'uitlaat'
 		WHEN manh_manhole_indicator = 2 THEN 'pomp'
        ELSE 'overige'
 		END as typeknooppunt,
        manh_bottom_level AS z_coordinaat,
        manh_surface_level AS maaiveldhoogte,
        the_geom AS the_geom
    FROM v2_manhole_view;""",
    "leiding": """CREATE OR REPLACE VIEW {schema}.leiding AS
    SELECT
        pipe_code AS leiding,
        -- pipe_connection_node_start_code AS beginpuntleiding,
        -- pipe_connection_node_end_code AS eindpuntleiding,
        CASE
 		WHEN pipe_sewerage_type = 0 THEN 'gemengd_afvalwater'
 		WHEN pipe_sewerage_type = 1 THEN 'afvloeiend_hemelwater'
 		WHEN pipe_sewerage_type = 2 THEN 'droogweerafvoer'
 		END as typeinzameling,
        pipe_invert_level_start_point AS bobbeginpuntleiding,
        pipe_invert_level_end_point AS bobeindpuntleiding,
        CASE
 		WHEN pipe_material = 0 THEN 'beton'
 		WHEN pipe_material = 1 THEN 'pvc'
 		WHEN pipe_material = 2 THEN 'gres'
 		WHEN pipe_material = 3 THEN 'gietijzer'
 		WHEN pipe_material = 4 THEN 'metselwerk'
 		WHEN pipe_material = 5 THEN 'polyetheen'
 		WHEN pipe_material = 6 THEN 'hdpe'
 		WHEN pipe_material = 7 THEN 'plaatijzer'
 		WHEN pipe_material = 8 THEN 'staal'
 		END as materiaalleiding,
        CASE
 		WHEN def_shape = 1 THEN 'rechthoekig'
 		WHEN def_shape = 2 THEN 'rond'
 		WHEN def_shape = 3 THEN 'eivormig'
 		WHEN def_shape = 5 THEN 'tabulated'
 		WHEN def_shape = 6 THEN 'trapezium'
 		END as vormprofiel,
        def_width AS breedteleiding,
        def_height AS hoogteleiding,
        the_geom AS the_geom
    FROM v2_pipe_view;""",
    "overstort": """CREATE OR REPLACE VIEW {schema}.overstort AS
    SELECT
        weir_connection_node_start_id AS beginpuntoverstort,
        weir_connection_node_end_id AS eindpuntoverstort,
        weir_discharge_coefficient_positive AS afvoercoefficient,
        weir_crest_level AS drempelniveau,
        def_width AS drempelbreedte,
        def_height AS vrijeoverstorthoogte,
        the_geom AS the_geom
    FROM v2_weir_view;""",
    "doorlaat": """CREATE OR REPLACE VIEW {schema}.doorlaat AS
    SELECT
        orf_connection_node_start_id AS beginpuntdoorlaat,
        orf_connection_node_end_id AS eindpuntdoorlaat,
        -- orf_max_capacity AS maximalecapaciteitdoorlaat,
        orf_discharge_coefficient_positive AS contractiecoefficientdoorlaatprofiel,
        orf_crest_level AS doorlaatniveau,
        CASE
 		WHEN def_shape = 1 THEN 'rechthoekig'
 		WHEN def_shape = 2 THEN 'rond'
 		WHEN def_shape = 3 THEN 'eivormig'
 		WHEN def_shape = 5 THEN 'tabulated'
 		WHEN def_shape = 6 THEN 'trapezium'
 		END as vormprofiel,
        def_width AS breedteleiding,
        def_height AS hoogteleiding,
        the_geom AS the_geom
    FROM v2_orifice_view;""",
    "pomp": """CREATE OR REPLACE VIEW {schema}.pomp AS
    SELECT
        pump_connection_node_start_id AS beginpuntpomp,
        pump_connection_node_end_id AS eindpuntpomp,
        pump_capacity AS pompcapaciteit,
        CASE
            WHEN pump_type = 1 THEN pump_start_level
            WHEN pump_type = 2 THEN NULL
 		END as aanslagniveaubovenstrooms,
        CASE
            WHEN pump_type = 1 THEN pump_lower_stop_level
            WHEN pump_type = 2 THEN NULL
 		END as afslagniveaubovenstrooms,
        CASE
            WHEN pump_type = 1 THEN NULL
            WHEN pump_type = 2 THEN pump_start_level
 		END as aanslagniveaubenedenstrooms,
        CASE
            WHEN pump_type = 1 THEN NULL
            WHEN pump_type = 2 THEN pump_lower_stop_level
 		END as afslagniveaubenedenstrooms,
        the_geom AS the_geom
    FROM v2_pumpstation_view;""",
}
