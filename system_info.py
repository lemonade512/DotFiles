""" Tools for retrieving information about user's system.

The install script in this repository aims to support as many environments as
possible, and each environment has its own tools for package management and
configuration. The tools in this file are meant to detect information about the
current system in a portable fashion that works with both Python 2 and
Python 3.
"""

import logging
import platform


def get_platform():
    if platform.uname()[0] == "Darwin":
        return "darwin"
    elif platform.uname()[0] == "Linux":
        linux_distro = platform.dist()[0]
        if linux_distro == "Ubuntu":
            return "debian"
        return linux_distro
    else:
        logging.error("Unkown platform {}".format(platform.platform()))
        return None

if __name__ == "__main__":
    print("Operating system detected: {}".format(get_platform()))
