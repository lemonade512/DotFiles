#!/usr/bin/env python
""" Initializes development environment.

This script is meant to be used to get my development environment set up
quickly on any machine that I use.
"""

from __future__ import print_function

import logging
import os

from halo import Halo
from jinja2 import Template

ROOT = os.path.abspath(os.path.dirname(__file__))
LOG_FILE = os.path.join(ROOT, "logs/install.log")


def setup_logging(logfile, loglevel):
    print(
        "Setting up logging. If you have problems see the", logfile, "file."
    )
    if not os.path.exists(os.path.dirname(logfile)):
        os.makedirs(os.path.dirname(logfile))
    logging.basicConfig(
        filename=logfile,
        level=loglevel
    )


if __name__ == "__main__":
    setup_logging(LOG_FILE, logging.INFO)
