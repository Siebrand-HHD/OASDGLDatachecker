-------------------------------------------------------------------------------------------
--- Empty 3Di database
--- Input: 3Di model in work_db
--- Output: empty 3Di model in work_db
-------------------------------------------------------------------------------------------
DELETE FROM v2_global_settings;
DELETE FROM v2_manhole;
DELETE FROM v2_pipe;
DELETE FROM v2_culvert;
DELETE FROM v2_weir;
DELETE FROM v2_windshielding;
DELETE FROM v2_levee;
DELETE FROM v2_obstacle;
DELETE FROM v2_orifice;
DELETE FROM v2_floodfill;
DELETE FROM v2_pumpstation;
DELETE FROM v2_impervious_surface;
DELETE FROM v2_impervious_surface_map;
DELETE FROM v2_pumped_drainage_area;
DELETE FROM v2_1d_boundary_conditions;
DELETE FROM v2_cross_section_definition;
DELETE FROM v2_cross_section_location;
DELETE FROM v2_grid_refinement;
DELETE FROM v2_1d_lateral;
DELETE FROM v2_2d_lateral;
DELETE FROM v2_channel;
DELETE FROM v2_2d_boundary_conditions;
DELETE FROM v2_connection_nodes;
DELETE FROM v2_dem_average_area;
DELETE FROM v2_control_group;
DELETE FROM v2_control;
DELETE FROM v2_numerical_settings;
DELETE FROM v2_interflow;
DELETE FROM v2_simple_infiltration;
DELETE FROM v2_groundwater;
DELETE FROM v2_control_measure_group;
DELETE FROM v2_control_measure_map;
DELETE FROM v2_control_table;
DELETE FROM v2_control_memory;