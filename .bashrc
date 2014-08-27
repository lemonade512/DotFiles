# vim:foldmethod=marker:foldlevel=0

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Source Files {{{

# Source global definitions {{{
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

if [ -f /etc/bash.bashrc ]; then
	. /etc/bash.bashrc
fi

if [ -f "/etc/DIR_COLORS" ]; then
    eval $(dircolors -b /etc/DIR_COLORS)
fi

# enable programmable completion features
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# }}}

if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi

if [ -f ~/.bash_functions ]; then
	. ~/.bash_functions
fi

# enable color support of ls
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# }}}

# ANSI color codes {{{
RS=$'\[\033[00m\]'    # reset
HC=$'\[\033[01m\]'    # hicolor
UL=$'\[\033[04m\]'    # underline
INV=$'\[\033[07m\]'   # inverse background and foreground
FBLK=$'\[\033[30m\]' # foreground black
FRED=$'\[\033[31m\]' # foreground red
FGRN=$'\[\033[32m\]' # foreground green
FYEL=$'\[\033[33m\]' # foreground yellow
FBLE=$'\[\033[34m\]' # foreground blue
FMAG=$'\[\033[35m\]' # foreground magenta
FCYN=$'\[\033[36m\]' # foreground cyan
FWHT=$'\[\033[37m\]' # foreground white
BBLK=$'\[\033[40m\]' # background black
BRED=$'\[\033[41m\]' # background red
BGRN=$'\[\033[42m\]' # background green
BYEL=$'\[\033[43m\]' # background yellow
BBLE=$'\[\033[44m\]' # background blue
BMAG=$'\[\033[45m\]' # background magenta
BCYN=$'\[\033[46m\]' # background cyan
BWHT=$'\[\033[47m\]' # background white
# }}}

# History Control {{{
# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

HISTSIZE=1000
HISTFILESIZE=2000
# }}}

# Bash Options {{{

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# correct minor errors in 'cd' commands
shopt -s cdspell

# Bash command editing works like vi
set -o vi

export EDITOR=/usr/bin/vim
export TERM=xterm-256color
# }}}

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Prompt {{{

PS1="\n${HC}[ ${RS}${FRED}\u@\h ${RS}${HC}] ${HC}${FGRN}\w${RS}\n${HC}${FRED}\$${RS} "
#PS1='\n\[\033[01m\][ \[\033[00;34m\]\u@\h \[\033[00m\]\[\033[01m\]] \[\033[01;32m\]\w\[\033[00m\]\n\[\033[01;34m\]$\[\033[00m\]'

# }}}

# LESS man page colors {{{

export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# }}}

if [ -e "$HOME/DotFiles/z/z.sh" ]; then
	. "$HOME/DotFiles/z/z.sh"
fi

export PYTHONPATH="${PYTHONPATH}:$HOME/Documents/PythonProjects/RPG"
