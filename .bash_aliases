#!/bin/bash

# General Commands {{{
alias grep="grep --color=auto"
alias fgrep="grep -F"
alias egrep="grep -E"

# Prompt if overrite
alias mv="mv -i"
alias cp="cp -i"
alias rm="rm -I"

alias grepn="grep -s -I -n --color=auto"

#NOTE this overrides an existing linux command called open
alias open="file_open"

# Example usage: grep "Some string" * && alert "Message"
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

alias pylint="pylint --rcfile ~/.pylintrc"

alias ls="ls --color=auto"
alias ll="ls -alF"
alias la="ls -A"

# }}}

# Shortcuts {{{
alias vbrc="vim ~/.bashrc && source ~/.bashrc"
alias back="cd - > /dev/null"
alias h="history | grep"
alias reload="source ~/.bashrc"
alias realias="$EDITOR ~/.bash_aliases; source ~/.bash_aliases"
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
