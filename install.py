#!/usr/bin/env python
""" Initializes development environment.

This script is meant to be used to get my development environment set up
quickly on any machine that I use.
"""

from __future__ import print_function

import datetime
import logging
import os

from halo import Halo
from jinja2 import Template

from cli import get_email, get_full_name, user_input
from system_info import get_platform
from package_config import default_package_managers, package_aliases
from setup_tools import install_homebrew

ROOT = os.path.abspath(os.path.dirname(__file__))
HOME = os.path.expanduser("~")
LOG_FILE = os.path.join(ROOT, "logs/install.log")

# TODO (plemons): Add better print messages like in the original script that
# I created based on the robot.


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


def require(package):
    DefaultPackageManager = default_package_managers[get_platform()]
    command = DefaultPackageManager(package)
    if package in package_aliases:
        command = package_aliases[package].get(get_platform(), command)

    if command is None:
        return

    spinner = Halo(
        text="Installing {}".format(package), spinner="dots", placement="right"
    )
    spinner.start()
    successful = command.execute()
    if not successful:
        spinner.fail()
    else:
        spinner.succeed()


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


def ensure_directory(directory):
    """ Make sure directory exists """
    if os.path.exists(directory) and not os.path.isdir(directory):
        raise Exception("Backup directory cannot be created")

    if not os.path.exists(directory):
        os.makedirs(directory)


def _backup(file, backup_dir):
    # TODO (plemons): Write tests to make sure this works (create a temp user,
    # add some files, run _backup to hit all branches)
    ensure_directory(backup_dir)
    os.path.rename(file, os.path.join(backup_dir, file))


def create_symlinks(src, dst, backup_dir):
    """ Creates symbolic links for all files in source.

    This will create a symbolic link in dst for all files in src. If a file
    already exists in dst, it will be moved to the specified backup directory.

    Args:
        src (str): The source directory with files and directories to link.
        dst (str): Where the new symbolic links will be created.
        backup_dir (str): Path to a directory for backup up existing files.
    """
    # TODO (plemons): Add Halo spinner checkmarks and Xs for success and errors
    for file in os.listdir(src):
        message = "linking %s" % file
        spinner = Halo(text=message, spinner="dots", placement="right")
        spinner.start()
        original = os.path.join(src, file)
        target = os.path.join(dst, file)
        if os.path.islink(target):
            os.unlink(target)

        if os.path.exists(target):
            _backup(target, backup_dir)

        os.symlink(original, target)
        spinner.succeed()


if __name__ == "__main__":
    # TODO (plemons): Install requirements.txt before imports
    setup_logging(LOG_FILE, logging.INFO)
    fullname = get_full_name()
    email = get_email()
    file(
        "~/.gitconfig",
        "gitconfig.template",
        fullname=fullname,
        email=email
    )
    backup_time = datetime.datetime.now().strftime("%Y.%m.%d.%H.%M.%S")
    backup_dir = os.path.join(
        HOME, os.path.join(".dotfiles_backup", backup_time)
    )
    print("Installing top-level dotfiles")
    create_symlinks(
        os.path.join(ROOT, "homedir"), HOME, backup_dir
    )
    print("Installing .config dotfiles")
    ensure_directory(os.path.join(HOME, ".config"))
    create_symlinks(
        os.path.join(ROOT, "config"), os.path.join(HOME, ".config"), backup_dir
    )

    # This must go after we install .config dotfiles so the symlink to the
    # nvim directory has been created before we render the template.
    file(
        "~/.config/nvim/init.vim",
        "init.vim.template",
        home=HOME
    )

    plat = get_platform()
    if plat == "darwin":
        install_homebrew()

    require("tmux")
    require("git")
    require("make")
    require("gcc")
    require("python-dev")
