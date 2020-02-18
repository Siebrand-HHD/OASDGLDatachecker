# -*- coding: utf-8 -*-
""" TODO Docstring. """
import os
import logging

from OASDGLDatachecker.tool_quality_checks import sql_checks
from OASDGLDatachecker.tool_quality_checks.sql_views import sql_views
from OASDGLDatachecker.tool_quality_checks.sql_background_views import (
    sql_background_views,
)

logger = logging.getLogger(__name__)


def quality_checks(db, settings):
    """Overall function for checking our model data"""

    # TODO always run this settings?
    initialize_db_checks(db)

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
            view_dictionary=sql_background_views, view_table=table, view_schema=schema
        )

    # install all functions out of folder "sql_functions"
    sql_reldir = "sql_functions"
    sql_absdir = os.path.join(os.path.dirname(__file__), sql_reldir)
    db.execute_sql_dir(sql_absdir)


def perform_checks_with_sql(db, settings, check_table, check_type):
    """
        Performs quality checks on postgres DB

        :param check_table - list of one or more structure tables (e.g. v2_manhole)
        :param check_type - select type of check: completeness, quality
        """
    check_table = check_table.replace("v2_", "")
    sql_template_name = "sql_" + check_type + "_" + check_table
    if sql_template_name in sql_checks.sql_checks:
        try:
            statement = sql_checks.sql_checks[sql_template_name].format(
                **settings.__dict__
            )
        except KeyError as e:
            raise KeyError("Setting %s is missing in the ini-file" % e)
        db.execute_sql_statement(sql_statement=statement, fetch=False)
