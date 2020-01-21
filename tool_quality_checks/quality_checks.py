# -*- coding: utf-8 -*-
""" TODO Docstring. """
import logging

from OASDGLDatachecker.tool_quality_checks.db import ThreediDatabase

logger = logging.getLogger(__name__)


def quality_checks(settings):
    """Overall function for checking our model data"""

    # get database connection
    db = ThreediDatabase(settings)
    # TODO: Make it only if install is on.
    db.initialize_db_checks()

    # get v2_table_names
    v2_table_names = db.select_table_names("v2%")
    for table_name in v2_table_names:
        if db.get_count(table_name) > 0:
            db.perform_checks_with_sql(settings, table_name, check_type="completeness")
            db.perform_checks_with_sql(settings, table_name, check_type="quality")

    db.populate_geometry_columns()
