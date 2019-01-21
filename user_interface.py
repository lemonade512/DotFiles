""" Contains print functions. """

from colors import Fore, Style


def bot(string):
    bot_string = Fore.GREEN + "\\[._.]/" + Style.RESET
    print("\n" + bot_string + " - " + string)
