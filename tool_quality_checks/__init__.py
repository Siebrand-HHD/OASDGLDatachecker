# package
import os
import logging

logger = logging.getLogger(__name__)

os.environ["SHAPE_ENCODING"] = "ISO-8859-4"
logger.info("changing shape encoding to ISO-8859-4")
