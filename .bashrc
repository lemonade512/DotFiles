# vim:foldmethod=marker:foldlevel=0

# ANSI color codes
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


# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

PS1="\n${HC}[ ${RS}${FRED}\u@\h ${RS}${HC}] ${HC}${FGRN}\w${RS}\n${HC}${FRED}\$${RS} "
#PS1='\n\[\033[01m\][ \[\033[00;34m\]\u@\h \[\033[00m\]\[\033[01m\]] \[\033[01;32m\]\w\[\033[00m\]\n\[\033[01;34m\]$\[\033[00m\]'

alias solarize='~/.solarized/solarize.sh'
alias vim='gvim'

# correct minor errors in 'cd' commands
shopt -s cdspell

# Bash command editing works like vi
set -o vi

# LESS man page colors--------------------------------------------------

export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'
