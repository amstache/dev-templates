import logging

from .example import slugify

log = logging.getLogger(__name__)


def main() -> None:
    logging.basicConfig(level=logging.INFO, format="%(message)s")
    log.info(slugify("Hello World"))
