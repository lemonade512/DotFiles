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

from cli import get_full_name, user_input
from system_info import get_platform
#from package_config import default_package_managers, package_aliases

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


def file(path, template_file, **kwargs):
    """ Installs a file using symlinks.

    If a file already exists at the specified path and it is not a symbolic
    link, then this function will print an error and return.

    Args:
        path (str): Filesystem path where we should install the filled out
            template file.
        template_file (str): The filename of the template to install. The
            file should be located in the $ROOT/templates directory of this
            repository.
        **kwargs: This is the list of input parameters for the tamplate.
    """
    spinner = Halo(text=path, spinner="dots", placement="right")
    spinner.start()
    if os.path.exists(path) and not os.path.islink(path):
        print("Error: {} exists and is not a soft link".format(path))
        spinner.fail()
        return

    try:
        # Load template as a Jinja2 Template
        template_path = os.path.join(
            ROOT, os.path.join("templates", template_file)
        )
        with open(template_path, "r") as template_file:
            template = Template(template_file.read())

        # Write filled out file to build directory of repository
        build_path = os.path.join(
            ROOT, os.path.join("build", os.path.basename(path))
        )
        if not os.path.exists(os.path.dirname(build_path)):
            os.makedirs(os.path.dirname(build_path))
        with open(build_path, 'w') as outfile:
            outfile.write(template.render(**kwargs))

        # Make sure to expand the home directory when necessary
        path = os.path.expanduser(path)
        dirpath = os.path.dirname(path)
        if not os.path.exists(dirpath):
            os.makedirs(dirpath)
        if os.path.islink(path):
            os.unlink(path)
        os.symlink(build_path, path)
        spinner.succeed()
    except OSError as err:
        print(err)
        spinner.fail()


if __name__ == "__main__":
    # TODO (plemons): Install requirements.txt before imports
    setup_logging(LOG_FILE, logging.INFO)
    fullname = get_full_name()
    email = user_input("What is your email? ")
    file(
        "~/.gitconfig",
        "gitconfig.template",
        fullname=fullname,
        email=email
    )

