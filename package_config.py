""" Configuration options for package nam aliases based on platform.

This file contains configuration for the default package managers on all
supported platforms and optional configuration to define aliases for different
packages on certain platforms. As an example, CentOS uses the convention that
development packages end with -devel, whereas the same package for Ubuntu ends
with -dev.

    $ sudo apt-get install unixodbc-dev  # Ubuntu
    $ sudo yum install unixodbc-devel    # CentOS
"""

import os

from package_managers import Brew, Apt, Yum, GitHub


ROOT = os.path.abspath(os.path.dirname(__file__))

default_package_managers = {'darwin': Brew, 'debian': Apt}

package_aliases = {
    'httpd': {
        'debian': Apt("apache")
    },
    'python-dev': {
        'centos': Yum("python-devel"),
        "darwin": None
    },
    'nvm': {
        'debian': None
    },
    'zsh-powerlevel9k': {
        'default': GitHub(
            "https://github.com/bhilburn/powerlevel9k.git",
            os.path.join(ROOT, "oh-my-zsh/custom/themes/powerlevel9k")
        )
    },
    'zsh-autosuggestions': {
        'default': GitHub(
            "https://github.com/zsh-users/zsh-autosuggestions",
            os.path.join(ROOT, "oh-my-zsh/custom/plugins/zsh-autosuggestions")
        )
    },
    'zsh-syntax-highlighting': {
        'default': GitHub(
            "https://github.com/zsh-users/zsh-syntax-highlighting.git",
            os.path.join(ROOT, "oh-my-zsh/custom/plugins/zsh-syntax-highlighting")
        )
    }
}
