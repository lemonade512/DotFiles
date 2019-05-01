""" Defines terminal escape codes for colors. """

class Fore:
    """ Foreground colors """
    RED = "\033[31m"
    GREEN = "\033[32m"
    YELLOW = "\033[33m"
    RESET = "\033[39m"


class Back:
    """ Background colors """
    RED = "\033[41m"
    GREEN = "\033[42m"
    YELLOW = "\033[43m"
    RESET = "\033[49m"


class Style:
    """ Miscellaneous style changes """
    RESET = "\033[00m"


if __name__ == "__main__":
    print(Fore.RED + "Red" + Fore.RESET)
    print(Fore.GREEN + "Green" + Fore.RESET)
    print(Fore.YELLOW + "Yellow" + Style.RESET)
    print(Back.RED + "Red" + Back.RESET)
    print(Back.GREEN + "Green" + Back.RESET)
    print(Back.YELLOW + "Yellow" + Back.RESET)
