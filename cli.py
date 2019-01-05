""" Tools for making Python easier to use with shell commands. """

from __future__ import print_function

import abc
from getpass import getpass
from subprocess import Popen, PIPE
import threading


# Need an input function that is compatible with Python 2.7 and Python 3.6
try:
    input = raw_input
except NameError:
    pass


def get_email():
    username, stderr = shell(["whoami"])
    print("Username:", username)
    stdout, stderr = shell([
        "dscl",
        ".",
        "-read",
        "/Users/" + str(username.strip())
    ])
    try:
        stdout, stderr = shell(["grep", "EMailAddress"], stdin=stdout)
        email, stderr = shell(["sed", "s/EMailAddress: //"], stdin=stdout)
    except ShellError:
        return None
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


class ShellError(Exception):

    def __init__(self, message, returncode, stdout, stderr):
        super(ShellError, self).__init__(message)
        self.returncode = returncode
        self.stdout = stdout
        self.stderr = stderr


def shell(command, sudo=False, stdin=None):
    """ Runs a shell command.

    Below is a series of examples for how to use this function.

        >>> stdout, stderr = shell(["ls"])
        >>> try:
        ...     shell(["grep", "test", "test.txt"])
        ... except:
        ...     print("Could not find 'test' in 'test.txt'")

    Args:
        command (list): A list where the first element is the command to
            excecute, and the following elements are arguments to be passed to
            that command.
        sudo (bool): Whether or not to elevate privileges using sudo. Defaults to
            False.

    Returns:
        (str, str): A tuple of the output from stdout and stderr.
    """
    if sudo:
        if stdin:
            # TODO (plemons): Make this possible somehow?
            raise Exception("Can't pass stdin to sudo commands")
        stdout, stderr, returncode = _sudo_shell(command)
    else:
        stdout, stderr, returncode = _user_shell(command, stdin=stdin)

    if returncode != 0:
        raise ShellError(
            "`{}` returned error code {}".format(" ".join(command), returncode),
            returncode, stdout, stderr
        )
    return stdout, stderr


def _user_shell(command, stdin=None):
    proc = Popen(
        command,
        stdin=PIPE,
        stdout=PIPE,
        stderr=PIPE,
        universal_newlines=True
    )
    stdout, stderr = proc.communicate(stdin)
    return stdout, stderr, proc.returncode


def _sudo_shell(command):
    if not Authentication.sudo_pass:
        raise AuthenticationError("Could not authenticate user")

    proc = Popen(
        ["sudo", "-S"] + command,
        stdin=PIPE,
        stdout=PIPE,
        stderr=PIPE,
        universal_newlines=True
    )
    stdout, stderr = proc.communicate(Authentication.sudo_pass + "\n")
    return stdout, stderr, proc.returncode


def user_input(message):
    return input(message)


if __name__ == "__main__":
    print(get_email())
    with Authentication():
        print(shell(["whoami"], sudo=True)[0])
    print(shell(["whoami"])[0])
    print(shell(["whoami"], sudo=True)[0])
