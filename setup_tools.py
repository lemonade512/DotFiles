""" Installation for necessary tools. """

from halo import Halo

import sh
import logging

from cli import user_input


BREW_GITHUB = (
    "https://raw.githubusercontent.com/Homebrew/install/master/install"
)


def install_homebrew():
    """ Installs or upgrades homebrew on mac.

    If homebrew is not installed, this command will install it, otherwise
    it will update homebrew to the latest version. Additionally, it will
    offer to upgrade all homebrew packages. Upgrading all packages can take
    a long time, so the user is given the choice to skip the upgrade.
    """
    print("Checking homebrew install")
    if sh.which("brew"):
        spinner = Halo(
            text="Updating homebrew", spinner="dots", placement="right"
        )
        spinner.start()
        sh.brew("update")
        spinner.succeed()
        print(
            "Before using homebrew to install packages, we can upgrade "
            "any outdated packages."
        )
        response = user_input("Run brew upgrade? [y|N] ")
        if response[0].lower() == "y":
            spinner = Halo(
                text="Upgrade brew packages", spinner="dots", placement="right"
            )
            spinner.start()
            sh.brew("upgrade")
            spinner.succeed()
        else:
            print("Skipped brew package upgrades")
    else:
        # TODO (phillip): Currently, this homebrew installation does not work on a fresh
        # computer. It works from the command line, but not when run from the script. I
        # need to figure out what is going on. It could be because user input is needed.
        spinner = Halo(
            text="Installing homebrew", spinner="dots", placement="right"
        )
        spinner.start()
        try:
            script = sh.curl("-fsSL", BREW_GITHUB).stdout
            sh.ruby("-e", script)
            spinner.succeed()
        except sh.ErrorReturnCode:
            logging.error("Unable to install homebrew. Aborting...")
            spinner.fail()
            exit(1)


if __name__ == "__main__":
    install_homebrew()
