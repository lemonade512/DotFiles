""" Tools for making Python easier to use with shell commands. """

from __future__ import print_function

import abc
from getpass import getpass
from subprocess import Popen, PIPE
import threading

from sh import dscl, ErrorReturnCode, grep, sed, whoami, osascript
from sh.contrib import sudo


# Need an input function that is compatible with Python 2.7 and Python 3.6
try:
    input = raw_input
except NameError:
    pass


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
        print("I see your name is {}.".format(fullname))
        response = user_input("Is that correct? [Y/n]")

    if response.lower().startswith("n"):
        first = user_input("What is your first name? ")
        last = user_input("What is your last name? ")
        fullname = first + " " + last

    return fullname


def get_email():
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


class AuthenticationError(Exception):
    pass


class Authentication:

    sudo_pass = None    # currently authenticated
    _sudo_pass = None   # saved sudo pass

    def __enter__(self):
        if Authentication._sudo_pass is None:
            Authentication.authenticate()
        Authentication.sudo_pass = Authentication._sudo_pass

    def __exit__(self, *args):
        Authentication.sudo_pass = None

    @staticmethod
    def authenticate():
        sudo_pass = getpass("Please enter your sudo password: ")
        if Authentication._validate(sudo_pass):
            Authentication._sudo_pass = sudo_pass
        else:
            print("Error: User entered invalid sudo password")
            exit(1)

    @staticmethod
    def _validate(password):
        sudo_proc = Popen(
            ["sudo", "-Sk", "whoami"],
            stdin=PIPE,
            stdout=PIPE,
            stderr=PIPE,
            universal_newlines=True
        )
        timer = threading.Timer(1.0, lambda: sudo_proc.kill())
        try:
            timer.start()
            sudo_proc.communicate(password + '\n')
            if sudo_proc.returncode == 0:
                return True
            return False
        finally:
            timer.cancel()


# This creates a parent class for abstract classes that is compatible with
# Python 2 and 3. See the following stackoverflow answer for more info:
# https://stackoverflow.com/questions/35673474/using-abc-abcmeta-in-a-way-it-is-compatible-both-with-python-2-7-and-python-3-5
ABC = abc.ABCMeta("ABC", (object, ), {"__slots__": ()})

class CommandInterface(ABC):
    """ Interface for creating executable commands.

    This interface allows developers to define classes that execute commands
    when their `execute` method is called. Here are a few possible use cases
    for extending this class:

        * Creating classes for a command that has a different syntax on
          different platforms (eg. Mac and Linux)
        * Creating commands that can be serialized and deserialized for RPC

    All methods in this parent class are marked as abstract and should be
    extended in child classes.
    """

    @abc.abstractmethod
    def execute(self):
        """ Executes a console command.

        Returns:
            True if the command executed successfully, False otherwise.

            For commands that are installing packages, the return value should
            be True if the package was installed correctly and False if there
            was a problem. If the package had already been installed, then the
            command should return True.
        """
        raise NotImplementedError


def user_input(message):
    return input(message)


if __name__ == "__main__":
    print(get_full_name())
    #print(get_email())
    with sudo:
        print(whoami().stdout.strip())
    print(whoami().stdout.strip())
