""" Tools for making Python easier to use with shell commands. """

from __future__ import print_function

from sh import dscl, ErrorReturnCode, grep, sed, whoami, osascript

from colors import Fore
from sh.contrib import sudo


def read_user_fullname():
    """ Reads user's full name from system config files.

    This function attempts to determine the current user's full name by reading
    system configuration files. If that is unsuccesful, None is returned.

    Returns:
        str: The user's full name, or None if not found.
    """
    try:
        fullname = osascript(
            "-e" "long user name of (system info)"
        ).stdout.strip()
    except ErrorReturnCode:
        fullname = None

    if not fullname:
        try:
            username = whoami().stdout.strip()
            firstname = sed(
                grep(
                    dscl(".", "-read", "/Users" + username),
                    "FirstName"
                ),
                "s/FirstName: //"
            )
            lastname = sed(
                grep(
                    dscl(".", "-read", "/Users" + username),
                    "LastName"
                ),
                "s/LastName: //"
            )
            fullname = firstname + " " + lastname
        except ErrorReturnCode:
            fullname = None

    return fullname


def get_full_name():
    fullname = read_user_fullname()
    if not fullname:
        response = "n"
    else:
        print(
            "I see your name is " +
            Fore.YELLOW + str(fullname) + Fore.RESET
        )
        response = user_input("Is that correct? [Y/n]")

    if response.lower().startswith("n"):
        first = user_input("What is your first name? ")
        last = user_input("What is your last name? ")
        fullname = first + " " + last

    return fullname


def read_user_email():
    """ Reads user's email from system config files.

    Returns:
        str: The user's email, or None if not found.
    """
    email = None
    try:
        username = whoami().stdout.strip()
        email = sed(
            grep(
                dscl(".", "-read", "/Users/" + username),
                "EMailAddress"
            ),
            "s/EMailAddress: //"
        )
    except ErrorReturnCode:
        pass

    return email


def get_email():
    email = read_user_email()
    if not email:
        response = "n"
    else:
        # TODO (plemons): Add color to this and the get_fullname() prompt
        print(
            "The best I can make out, your email address is " +
            Fore.YELLOW + str(email) + Fore.RESET
        )
        response = user_input("Is that correct? [Y/n]")

    if response.lower().startswith("n"):
        email = user_input("What is your email? ")

    return email


if __name__ == "__main__":
    print(get_full_name())
    print(get_email())
    with sudo:
        print(whoami().stdout.strip())
    print(whoami().stdout.strip())
