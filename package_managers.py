""" Package management commands for Mac, Ubuntu, and CentOS. """

from __future__ import print_function

import logging
import os

import sh

from cli import Authentication, CommandInterface


class GitHub(CommandInterface):
    """ Clones packages from GitHub repositories. """

    def __init__(self, repo, dest):
        self.repo = repo
        self.dest = dest

    def execute(self):
        if os.path.exists(self.dest):
            return True

        try:
            sh.git("clone", self.repo, self.dest)
        except sh.ErrorReturnCode as err:
            err_message = "\n\t" + err.stderr.replace("\n", "\n\t")
            logging.error(
                "Error with `git clone %s`: %s",
                self.repo,
                err_message
            )
            return False
        return True


class Brew(CommandInterface):
    """ Installs packages using MacOS Homebrew. """

    def __init__(self, package):
        self.package = package

    def execute(self):
        try:
            sh.brew("list", self.package)
        except sh.ErrorReturnCode_1:
            try:
                sh.brew("install", self.package)
            except sh.ErrorReturnCode as err:
                err_message = "\n\t" + err.stderr.replace("\n", "\n\t")
                logging.error(
                    "Error with `brew install %s`: %s",
                    self.package,
                    err_message
                )
                return False

        return True


class Apt(CommandInterface):
    """ Installs packages on Debian-based computers. """

    def __init__(self, package):
        self.package = package

    def execute(self):
        try:
            sh.dpkg("-l", self.package)
        except sh.ErrorReturnCode_1:
            try:
                with Authentication():
                    sh.apt_get("install", "-y", self.package)
            except sh.ErrorReturnCode as err:
                err_message = "\n\t" + err.stderr.replace("\n", "\n\t")
                logging.error(
                    "Error with `apt-get install %s`: %s",
                    self.package,
                    err_message
                )
                return False

        return True


# TODO (plemons): All of these package manager classes look very similar. Is
# there a way we could reduce the amount of replicated code?
class Yum(CommandInterface):
    """ Installs packages on CentOS machines. """

    def __init__(self, package):
        self.package = package

    def execute(self):
        with Authentication():
            try:
                sh.yum("list", "installed", self.package)
            except sh.ErrorReturnCode_1:
                try:
                    sh.yum("install", "-y", self.package)
                except sh.ErrorReturnCode as err:
                    err_message = "\n\t" + err.stderr.replace("\n", "\n\t")
                    logging.error(
                        "Error with `sudo yum install %s`: %s",
                        self.package,
                        err_message
                    )
                    return False

            return True


# TODO (plemons): This currently installs using sudo. If we wanted to install
# into a virtual environment, we would need to run as the user instead of root.
class Pip(CommandInterface):
    """ Installs python packages using pip.

    This will install python packages using pip as the root user. This class
    will need to be updated if you want to install into a virtual environment.
    """

    def __init__(self, package):
        self.package = package

    def execute(self):
        with Authentication():
            try:
                sh.pip("show", self.package)
            except sh.ErrorReturnCode_1:
                try:
                    sh.pip("install", self.package)
                except sh.ErrorReturnCode as err:
                    err_message = "\n\t" + err.stderr.replace("\n", "\n\t")
                    logging.error(
                        "Error with `sudo pip install %s`: %s",
                        self.package,
                        err_message
                    )
                    return False

            return True


if __name__ == "__main__":
    from system_info import get_platform
    plat = get_platform()
    if plat == "darwin":
        print("Installing rolldice with homebrew")
        Brew("rolldice").execute()
    elif plat == "debian":
        print("Installing rolldice with apt-get")
        Apt("rolldice").execute()
    else:
        print("Unsupported platform:", plat)
