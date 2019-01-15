""" Configuration options for package nam aliases based on platform.

This file contains configuration for the default package managers on all
supported platforms and optional configuration to define aliases for different
packages on certain platforms. As an example, CentOS uses the convention that
development packages end with -devel, whereas the same package for Ubuntu ends
with -dev.

    $ sudo apt-get install unixodbc-dev  # Ubuntu
    $ sudo yum install unixodbc-devel    # CentOS
"""

from package_managers import Brew, Apt, Yum


default_package_managers = {'darwin': Brew, 'debian': Apt}

package_aliases = {
    'httpd': {
        'debian': Apt("apache")
    },
    'python-dev': {
        'centos': Yum("python-devel"),
        "darwin": None
    }
}
