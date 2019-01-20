""" Installation for necessary tools. """

from halo import Halo

import sh

from cli import user_input


BREW_GITHUB = (
    "https://raw.githubusercontent.com/Homebrew/install/master/install"
)


def install_homebrew():
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
        response = user_input("Run brew upgrade? [y|N]")
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
        print("Installing homebrew")
        try:
            script = sh.curl("-fsSL", BREW_GITHUB).stdout
            sh.ruby("-e", script)
        except sh.ErrorReturnCode:
            print("Unable to install homebrew. Aborting...")


if __name__ == "__main__":
    install_homebrew()
