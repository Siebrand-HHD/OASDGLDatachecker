# -*- coding: utf-8 -*-
""" Provide a list of checks regarding the sewerage system in a postgres db """
import os
import logging

from OASDGLDatachecker.tool_quality_checks.sql_check_views import sql_checks
from OASDGLDatachecker.tool_quality_checks.sql_views import sql_views
from OASDGLDatachecker.tool_quality_checks.sql_model_views import (
    sql_understandable_model_views,
)
from OASDGLDatachecker.tool_quality_checks.point_sampling import (
    sample_points_and_create_pg_layer,
    create_point_sample_layer,
)
from OASDGLDatachecker.tool_quality_checks.import_management_database import (
    set_ogr_connection_pg_database,
)

OUR_DIR = os.path.dirname(__file__)
logger = logging.getLogger(__name__)


def check_sewerage(db, settings):
    """
    Overall function for checking our sewerage model data
    
    Result: list of check-tables in the postgres database in 'chk' schema
    """

    # Now the checks always run - option make it variable
    initialize_db_checks(db)

    # load dtm values
    if os.path.isfile(settings.dem):
        sample_points_and_create_pg_layer(
            settings,
            settings.dem,
            "v2_manhole_view",
            "manhole_maaiveld",
            "src",
            "maaiveld",
        )
    else:
        # create empty layer to make sure that sql does not crash on table unknown
        logger.warning("No DEM file is provided during sewerage checks")
        conn = set_ogr_connection_pg_database(settings)
        create_point_sample_layer(
            settings,
            conn,
            input_point_layer="v2_manhole_view",
            output_point_layer="manhole_maaiveld",
            output_schema="src",
            output_raster_column="maaiveld",
        )
        conn.Destroy()

    # get v2_table_names
    v2_table_names = db.select_table_names("v2%")
    for table_name in v2_table_names:
        if db.get_count(table_name) > 0:
            perform_checks_with_sql(db, settings, table_name, check_type="completeness")
            perform_checks_with_sql(db, settings, table_name, check_type="quality")

    db.populate_geometry_columns()


def initialize_db_checks(db):
    """ Initialize database for checks """

    db.create_schema(schema_name="chk")
    db.create_schema(schema_name="model")
    db.create_schema(schema_name="src")

    # install necessary functions out of folder "sql_functions"
    sql_relpath = os.path.join("sql", "sql_function_array_greatest_or_smallest.sql")
    sql_abspath = os.path.join(OUR_DIR, sql_relpath)
    db.execute_sql_file(sql_abspath)

    for schema, table in [
        ["public", "v2_1d_boundary_conditions_view"],
        ["public", "v2_pumpstation_point_view"],
        ["public", "v2_1d_lateral_view"],
        ["public", "v2_cross_section_definition_rio_view"],
        ["chk", "v2_pipe_view_left_join"],
        ["chk", "v2_orifice_view_left_join"],
        ["chk", "v2_weir_view_left_join"],
    ]:
        db.create_preset_view_from_dictionary(
            view_dictionary=sql_views, view_table=table, view_schema=schema
        )

    for schema, table in [
        ["model", "put"],
        ["model", "leiding"],
        ["model", "overstort"],
        ["model", "doorlaat"],
        ["model", "pomp"],
    ]:
        db.create_preset_view_from_dictionary(
            view_dictionary=sql_understandable_model_views,
            view_table=table,
            view_schema=schema,
        )


def perform_checks_with_sql(db, settings, check_table, check_type):
    """
        Performs quality checks on postgres DB

        :param check_table - list of one or more structure tables (e.g. v2_manhole)
        :param check_type - select type of check: completeness, quality
        """
    check_table = check_table.replace("v2_", "")
    sql_template_name = "sql_" + check_type + "_" + check_table

    if sql_template_name in sql_checks:
        try:
            statement = sql_checks[sql_template_name].format(
                schema="chk", **settings.__dict__
            )
        except KeyError as e:
            raise KeyError("Setting %s is missing in the ini-file" % e)
        db.execute_sql_statement(sql_statement=statement, fetch=False)
