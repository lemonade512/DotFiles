import abc
from sh.contrib import sudo
from getpass import getpass
from subprocess import Popen, PIPE
import threading


# Need an input function that is compatible with Python 2.7 and Python 3.6
try:
    input = raw_input
except NameError:
    pass


class AuthenticationError(Exception):
    pass


class Authentication:

    sudo = None         # currently authenticated
    _sudo_pass = None   # saved sudo pass

    def __enter__(self):
        if Authentication._sudo_pass is None:
            Authentication.authenticate()
        Authentication.sudo = sudo(
            password=Authentication._sudo_pass, _with=True
        )
        Authentication.sudo.__enter__()

    def __exit__(self, *args):
        Authentication.sudo.__exit__(*args)
        Authentication.sudo = None

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

