""" Contains print functions. """

from colors import Fore, Style


def bot(string):
    """ User friendly bot print function """
    bot_string = Fore.GREEN + "\\[._.]/" + Style.RESET
    print("\n" + bot_string + " - " + string)
