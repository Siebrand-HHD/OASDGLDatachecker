# -*- coding: utf-8 -*-

sql_views = {
    "v2_pumpstation_point_view": """
        CREATE OR REPLACE VIEW {schema}.v2_pumpstation_point_view AS
        SELECT a.id as pump_id, a.display_name, a.code, a.classification, a.sewerage, a.start_level, a.lower_stop_level, 
        a.upper_stop_level, a.capacity,
        a.zoom_category, a.connection_node_start_id, a.connection_node_end_id, b.id as connection_node_id, b.storage_area, b.the_geom
        FROM v2_pumpstation a JOIN v2_connection_nodes b ON a.connection_node_start_id = b.id;       
        """,
    "v2_1d_lateral_view": """
        CREATE OR REPLACE VIEW {schema}.v2_1d_lateral_view AS
        SELECT a.*, b.the_geom 
        FROM v2_1d_lateral a 
        JOIN v2_connection_nodes b ON a.connection_node_id = b.id;""",
    "v2_1d_boundary_conditions_view": """
        CREATE OR REPLACE VIEW {schema}.v2_1d_boundary_conditions_view AS
        SELECT a.*, b.the_geom 
        FROM v2_1d_boundary_conditions a 
        JOIN v2_connection_nodes b ON a.connection_node_id = b.id;""",
    "v2_cross_section_definition_rio_view": """
        CREATE OR REPLACE VIEW {schema}.v2_cross_section_definition_rio_view AS
        SELECT v2_cross_section_definition.*, 'weir' as structure_type, weir_id as structure_id, the_geom FROM v2_cross_section_definition JOIN v2_weir_view ON v2_cross_section_definition.id = weir_cross_section_definition_id
        UNION ALL
        SELECT v2_cross_section_definition.*, 'orifice' as structure_type, orf_id, the_geom FROM v2_cross_section_definition JOIN v2_orifice_view ON v2_cross_section_definition.id = orf_cross_section_definition_id
        UNION ALL
        SELECT v2_cross_section_definition.*, 'pipe' as structure_type, pipe_id, the_geom FROM v2_cross_section_definition JOIN v2_pipe_view ON v2_cross_section_definition.id = pipe_cross_section_definition_id;""",
    "v2_pipe_view_left_join": """CREATE OR REPLACE VIEW {schema}.v2_pipe_view_left_join AS
        SELECT pipe.id AS pipe_id,
            pipe.display_name AS pipe_display_name,
            pipe.code AS pipe_code,
            pipe.profile_num AS pipe_profile_num,
            pipe.sewerage_type AS pipe_sewerage_type,
            pipe.calculation_type AS pipe_calculation_type,
            pipe.invert_level_start_point AS pipe_invert_level_start_point,
            pipe.invert_level_end_point AS pipe_invert_level_end_point,
            pipe.cross_section_definition_id AS pipe_cross_section_definition_id,
            pipe.friction_value AS pipe_friction_value,
            pipe.friction_type AS pipe_friction_type,
            pipe.dist_calc_points AS pipe_dist_calc_points,
            pipe.material AS pipe_material,
            pipe.original_length AS pipe_original_length,
            pipe.zoom_category AS pipe_zoom_category,
            pipe.connection_node_start_id AS pipe_connection_node_start_id,
            pipe.connection_node_end_id AS pipe_connection_node_end_id,
            def.id AS def_id,
            def.shape AS def_shape,
            def.width AS def_width,
            def.height AS def_height,
            def.code AS def_code,
            st_makeline(start_node.the_geom, end_node.the_geom) AS the_geom
            FROM v2_pipe pipe
        LEFT JOIN v2_connection_nodes start_node
        ON 	pipe.connection_node_start_id = start_node.id 
        LEFT JOIN v2_connection_nodes end_node
        ON 	pipe.connection_node_end_id = end_node.id 
        LEFT JOIN v2_cross_section_definition def
        ON pipe.cross_section_definition_id = def.id
        ;""",
    "v2_orifice_view_left_join": """
        CREATE OR REPLACE VIEW {schema}.v2_orifice_view_left_join AS
        SELECT orf.id AS orf_id,
            orf.display_name AS orf_display_name,
            orf.code AS orf_code,
            orf.crest_level AS orf_crest_level,
            orf.sewerage AS orf_sewerage,
            orf.cross_section_definition_id AS orf_cross_section_definition_id,
            orf.friction_value AS orf_friction_value,
            orf.friction_type AS orf_friction_type,
            orf.discharge_coefficient_positive AS orf_discharge_coefficient_positive,
            orf.discharge_coefficient_negative AS orf_discharge_coefficient_negative,
            orf.zoom_category AS orf_zoom_category,
            orf.crest_type AS orf_crest_type,
            orf.connection_node_start_id AS orf_connection_node_start_id,
            orf.connection_node_end_id AS orf_connection_node_end_id,
            def.id AS def_id,
            def.shape AS def_shape,
            def.width AS def_width,
            def.height AS def_height,
            def.code AS def_code,
            st_makeline(start_node.the_geom, end_node.the_geom) AS the_geom
        FROM v2_orifice orf
        LEFT JOIN	v2_cross_section_definition def
        ON			orf.cross_section_definition_id = def.id
        LEFT JOIN	v2_connection_nodes start_node
        ON			orf.connection_node_start_id = start_node.id
        LEFT JOIN    v2_connection_nodes end_node
        ON			orf.connection_node_end_id = end_node.id
        ;
    """,
    "v2_weir_view_left_join": """
        CREATE OR REPLACE VIEW {schema}.v2_weir_view_left_join AS
        SELECT weir.id AS weir_id,
            weir.display_name AS weir_display_name,
            weir.code AS weir_code,
            weir.crest_level AS weir_crest_level,
            weir.crest_type AS weir_crest_type,
            weir.cross_section_definition_id AS weir_cross_section_definition_id,
            weir.sewerage AS weir_sewerage,
            weir.discharge_coefficient_positive AS weir_discharge_coefficient_positive,
            weir.discharge_coefficient_negative AS weir_discharge_coefficient_negative,
            weir.external AS weir_external,
            weir.zoom_category AS weir_zoom_category,
            weir.friction_value AS weir_friction_value,
            weir.friction_type AS weir_friction_type,
            weir.connection_node_start_id AS weir_connection_node_start_id,
            weir.connection_node_end_id AS weir_connection_node_end_id,
            def.id AS def_id,
            def.shape AS def_shape,
            def.width AS def_width,
            def.height AS def_height,
            def.code AS def_code,
            st_makeline(start_node.the_geom, end_node.the_geom) AS the_geom
        FROM v2_weir weir
        LEFT JOIN	v2_cross_section_definition def
        ON			weir.cross_section_definition_id = def.id
        LEFT JOIN	v2_connection_nodes start_node
        ON			weir.connection_node_start_id = start_node.id
        LEFT JOIN    v2_connection_nodes end_node
        ON			weir.connection_node_end_id = end_node.id
        ;""",
}
