#!/usr/bin/env python
""" Initializes development environment.

This script is meant to be used to get my development environment set up
quickly on any machine that I use. This script is designed to be run with
any version of Python, so it must support both Python 2.7 and Python 3.x.
"""
# TODO (phillip): Add testing for multiple versions of Python

from __future__ import print_function

import datetime
import logging
import os
import subprocess
import site
import sys
import sh
import tarfile


ROOT = os.path.abspath(os.path.dirname(__file__))
HOME = os.path.expanduser("~")
LOG_FILE = os.path.join(ROOT, "logs/install.log")

# Install latest version of setuptools
ret = subprocess.call(["pip", "install", "--user", "-U", "setuptools"])
if ret != 0:
    logging.error(
        "Error installing latest version of `setuptools`"
    )
    exit(1)

# Append `pip --user` install path
sys.path.append(site.USER_BASE)

# TODO (plemons): Implement method to check requirements before installing
# so we don't needlessly install
def install_requirements():
    ret = subprocess.call(["pip", "install", "--user", "-r", os.path.join(ROOT, "requirements.txt")])
    if ret != 0:
        logging.error(
            "Error with `sudo pip install -r requirements.txt`"
        )
print("Installing basic python requirements...")
install_requirements()


from halo import Halo
from jinja2 import Template

from cli import Authentication, CLI, get_platform
from package_config import default_package_managers, package_aliases
from setup_tools import install_homebrew
from user_interface import bot


# TODO (plemons): Add better print messages like in the original script that
# I created based on the robot.


def setup_logging(logfile, loglevel):
    """ Creates a directory for all logs during installation. """
    bot("Setting up logging. If you have problems see the {} file".format(logfile))
    if not os.path.exists(os.path.dirname(logfile)):
        os.makedirs(os.path.dirname(logfile))
    logging.basicConfig(
        filename=logfile,
        level=loglevel
    )


def require(package):
    """ Specifies a package that should be installed.

    By default, this method will use the default package manager of the OS
    (brew for Mac, apt-get for Ubuntu, etc.), but you can override the default
    package by specifying it in the `package_aliases.py` file.

    Args:
        package (str): User-friendly name of package. Most often, this will be
            the same as the actual name of the package in the package manager,
            but some packages will have different names on different systems.
            Use your best judgement to determine what name to use.
    """
    DefaultPackageManager = default_package_managers[get_platform()]
    command = DefaultPackageManager(package)
    if package in package_aliases:
        default = package_aliases[package].get('default', command)
        command = package_aliases[package].get(get_platform(), default)

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


# TODO (phillip): This dictionary and function need to be updated based on
# the platform.
keyboard = {
    'capslock': 0x700000039,
    'left-ctrl': 0x7000000E0
}

# Technical note describing remapping keys on mac
# https://developer.apple.com/library/archive/technotes/tn2450/_index.html
def remap_key(src, dest):
    """ Remaps src key to dest key.

    An example of remapping the caps lock key to act like the left control key
    would be to call `remap_key('capslock', 'left-ctrl')

    Args:
        src (str): Key name in keyboard dict. This is the key that will change
            functionality.
        dest (str): Key name in keyboard dict. The key defined in `src` should
            act like this key.
    """
    # TODO (phillip): Right now, these changes do not survive a reboot. I am
    # going to just change this manually in the keyboard settings, but I might
    # be able to figure out how to do it with `defaults`.
    # https://apple.stackexchange.com/questions/141069/updating-modifier-keys-from-the-command-line-takes-no-effect
    spinner = Halo(
        text="Remapping {} to {}".format(src, dest),
        spinner="dots",
        placement="right"
    )
    spinner.start()
    remap_dict = {
        'UserKeyMapping': [
            {
                'HIDKeyboardModifierMappingSrc': keyboard[src],
                'HIDKeyboardModifierMappingDst': keyboard[dest]
            }
        ]
    }
    try:
        sh.hidutil("property", "--set", str(remap_dict).replace("'", '"'))
        spinner.succeed()
    except sh.ErrorReturnCode as err:
        err_message = "\n\t" + err.stderr.replace("\n", "\n\t")
        logging.error(
            "Error with `hidutil property --set %s : %s",
            str(remap_dict),
            err_message
        )
        spinner.fail()


# TODO (phillip): Need to add support for Ubuntu to set up important configuration.
def configure(namespace, key, *values):
    """ Sets configuration on mac using `defaults` """
    spinner = Halo(
        text="Setting {}".format(key),
        spinner="dots",
        placement="right"
    )
    spinner.start()
    try:
        if namespace:
            sh.defaults("write", namespace, key, *values)
        else:
            sh.defaults("write", key, *values)
        spinner.succeed()
    except sh.ErrorReturnCode as err:
        err_message = "\n\t" + err.stderr.replace("\n", "\n\t")
        logging.error(
            "Error with `defaults write -g %s %s: %s", key, values, err_message
        )
        spinner.fail()


# TODO (phillip): Move this to a separate config file
font_library = {
    "Droid Sans Mono Nerd Font Complete.otf": "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete.otf"
}


def font(name):
    """ Installs fonts using curl.

    Args:
        name (str): The name of the font as defined in `font_library` dictionary.
    """
    spinner = Halo(
        text="Font {}".format(name),
        spinner="dots",
        placement="right"
    )
    spinner.start()
    try:
        library = os.path.join(HOME, "Library/Fonts")
        path = os.path.join(library, name)
        sh.curl("-fLo", path, font_library[name])
        spinner.succeed()
    except sh.ErrorReturnCode as err:
        err_message = "\n\t" + err.stderr.replace("\n", "\n\t")
        logging.error(
            "Error installing font `%s`: %s", name, err_message
        )
        spinner.fail()


def curl(src, dest):
    """ Installs `src` to path `dest` """
    spinner = Halo(
        text="curl {}".format(dest),
        spinner="dots",
        placement="right"
    )
    spinner.start()
    if os.path.exists(dest):
        spinner.info("{} already exists".format(dest))
        return

    try:
        sh.curl("-fLo", dest, src)
        spinner.succeed()
    except sh.ErrorReturnCode as err:
        err_message = "\n\t" + err.stderr.replace("\n", "\n\t")
        logging.error(
            "Error downloading file `%s`: %s", src, err_message
        )
        spinner.fail()


def extract(src, dest):
    """ Extracts the source file in dest """
    spinner = Halo(
        text="extract {}".format(src),
        spinner="dots",
        placement="right"
    )
    spinner.start()
    try:
        # TODO (phillip): This should choose the correct decompression based
        # on the filename where possible.
        with tarfile.open(src, "r:gz") as tar:
            tar.extractall(dest)
        sh.rm(src)
        spinner.succeed()
    except sh.ErrorReturnCode as err:
        err_message = "\n\t" + err.stderr.replace("\n", "\n\t")
        logging.error(
            "Error extracting file `%s`: %s", src, err_message
        )
        spinner.fail()


def default_shell(name):
    """ Sets default shell for the current user. """
    spinner = Halo(
        text="Default shell `{}`".format(name),
        spinner="dots",
        placement="right"
    )
    spinner.start()
    try:
        path = sh.which(name).strip()
        user = sh.whoami().strip()
        with Authentication():
            sh.chsh("-s", path, user)
        spinner.succeed()
    except sh.ErrorReturnCode as err:
        err_message = "\n\t" + err.stderr.replace("\n", "\n\t")
        logging.error(
            "Error changing default shell to %s: %s", name, err_message
        )
        spinner.fail()


def file(path, template_file, load_vars=lambda: {}):
    """ Installs a template file using symlinks.

    If a file already exists at the specified path and it is not a symbolic
    link, then this function will print an error and return. If the file is
    a symlink to the `build` directory of your dotfiles repo, then this will
    check to see if the template has been modified since the file was last
    built.

    Args:
        path (str): Filesystem path where we should install the filled out
            template file.
        template_file (str): The filename of the template to install. The
            file should be located in the $ROOT/templates directory of this
            repository.
        load_vars (func): A function that will be run when the file is built to
            fill in template information. This is passed in as a function so
            that user input is only asked for when the file is built.
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
        template_mtime = os.path.getmtime(template_path)
        with open(template_path, "r") as template_file:
            template = Template(template_file.read())

        build_path = os.path.join(
            ROOT, os.path.join("build", os.path.basename(path))
        )
        if not os.path.exists(build_path):
            build_mtime = 0
        else:
            build_mtime = os.path.getmtime(build_path)

        # Build the template if the template has been modified since last build
        if template_mtime > build_mtime:
            # TODO (plemons): I should only do this if I actually need user
            # input. Theoretically, the load_vars function could just read
            # from a config file making this unnecessary
            spinner.info("Asking for user input for {}".format(path))
            if not os.path.exists(os.path.dirname(build_path)):
                os.makedirs(os.path.dirname(build_path))
            with open(build_path, 'w') as outfile:
                outfile.write(template.render(**load_vars()))

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
    """ Make sure directory exists.

    Args:
        directory (str): Path to a directory you want to make sure exists. If
            the directory already exists, this method will do nothing.
            Otherwise, it will create the specified directory and all of its
            parent directories as needed.
    """
    if os.path.exists(directory) and not os.path.isdir(directory):
        raise Exception("Backup directory cannot be created")

    if not os.path.exists(directory):
        os.makedirs(directory)


def _backup(file, backup_dir):
    """ Copies a file to a backup directory.

    This function will make sure that the proper backup directory is created
    before copying the file to the backup directory.

    Args:
        file (str): Path to the file being backed up.
        backup_dir (str): Path to the backup directory
    """
    # TODO (plemons): Write tests to make sure this works (create a temp user,
    # add some files, run _backup to hit all branches)
    ensure_directory(backup_dir)
    os.path.rename(file, os.path.join(backup_dir, file))


def link(src, dest, backup_dir):
    """ Creates a symbolic link at the specified location.

    Args:
        src (str): Path to the file that we want to link to.
        dest (str): Path of the link that will be created.
        backupd_dir (str): Path to directory to backup existing files.
    """
    message = "linking %s" % os.path.basename(src)
    spinner = Halo(text=message, spinner="dots", placement="right")
    spinner.start()
    if os.path.islink(dest):
        os.unlink(dest)

    if os.path.exists(dest):
        _backup(dest, backup_dir)

    os.symlink(src, dest)
    spinner.succeed()


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
    for file_ in os.listdir(src):
        original = os.path.join(src, file_)
        target = os.path.join(dst, file_)
        link(original, target, backup_dir)


if __name__ == "__main__":
    # We have to authenticate here so that Authentication can use the sudo
    # password while installing packages. If we don't authenticate here, the
    # message telling the user to enter their sudo password may get overwritten
    # by the Halo spinner.
    with Authentication():
        pass

    setup_logging(LOG_FILE, logging.INFO)
    file(
        "~/.gitconfig",
        "gitconfig.template",
        load_vars=lambda: {
            'fullname': CLI.get_full_name(),
            'email': CLI.get_email()
        }
    )
    backup_time = datetime.datetime.now().strftime("%Y.%m.%d.%H.%M.%S")
    backup_dir = os.path.join(
        HOME, os.path.join(".dotfiles_backup", backup_time)
    )
    bot("Installing top-level dotfiles")
    create_symlinks(
        os.path.join(ROOT, "homedir"), HOME, backup_dir
    )
    bot("Installing .config dotfiles")
    ensure_directory(os.path.join(HOME, ".config"))
    create_symlinks(
        os.path.join(ROOT, "config"), os.path.join(HOME, ".config"), backup_dir
    )

    # This must go after we install .config dotfiles so the symlink to the
    # nvim directory has been created before we render the template.
    file(
        "~/.config/nvim/init.vim",
        "init.vim.template",
        load_vars=lambda: {
            'home': HOME
        }
    )

    plat = get_platform()
    if plat == "darwin":
        bot("Installing package managers")
        install_homebrew()

    bot("Installing tools")
    require("tmux")
    require("git")
    require("make")
    require("gcc")
    require("python-dev")
    require("docker")
    require("neovim")
    require("nmap")
    require("tree")
    require("wget")
    require("nvm")
    require("node")

    if plat == "darwin":
        bot("Configuring mac")
        #remap_key('capslock', 'left-ctrl')
        configure("-g", "com.apple.mouse.scaling", 4.0)
        configure("-g", "KeyRepeat", "-int", 1)
        configure(None, "com.apple.driver.AppleBluetoothMultitouch.mouse", "MouseButtonMode", "TwoButton")
        sh.defaults("-currentHost", "write", "com.apple.screensaver", "idleTime", "-int", "1800")

    bot("Installing Oh My Zsh")
    link(os.path.join(ROOT, "oh-my-zsh"), os.path.join(HOME, ".oh-my-zsh"), backup_dir)
    require("zsh-powerlevel9k")
    require("zsh-autosuggestions")
    require("zsh-syntax-highlighting")
    font("Droid Sans Mono Nerd Font Complete.otf")
    default_shell("zsh")

    bot("Installing brew casks")
    require("iterm2")
    require("anki")

    bot("Installing Google Cloud SDK")
    sdk_url = "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-244.0.0-darwin-x86_64.tar.gz"
    curl(sdk_url, os.path.join(HOME, "gcloud.tar.gz"))
    extract(os.path.join(HOME, "gcloud.tar.gz"), HOME)

    # TODO (plemons): Make this yellow so it is more visible.
    bot("You will need to logout and log in again to make some configuration work")
