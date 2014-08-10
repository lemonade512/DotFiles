#!/bin/bash

# General Commands {{{
alias grep="grep --color=auto"
alias fgrep="grep -F"
alias egrep="grep -E"

alias grepn="grep -s -I -n --color=auto"

alias ls="ls --color=auto"
alias la="ls -A"
alias ll="ls -l"
# }}}

# Shortcuts {{{
alias vbrc="vim ~/.bashrc && source ~/.bashrc"
alias pylint="pylint --rcfile ~/.pylintrc"
alias back="cd $OLDPWD"
alias h="history | grep"
alias reload="source ~/.bashrc"
# }}}

# Package Management {{{
alias install="sudo apt-get install"
alias remove="sudo apt-get remove"
# }}}

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

alias solarize='~/.solarized/solarize.sh'

# vim:foldmethod=marker:foldlevel=0
