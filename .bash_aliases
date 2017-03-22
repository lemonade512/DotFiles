#!/bin/bash

# General Commands {{{
alias grep="grep --color=auto"
alias fgrep="grep -F"
alias egrep="grep -E"

# Use macvim on mac
if [ "$(uname -s)" = "Darwin" ]; then
    alias vim="/Applications/MacVim.app/Contents/MacOS/Vim"
fi

# Prompt if overrite
alias mv="mv -i"
alias cp="cp -i"
if [ "$(uname -s)" != "Darwin" ]; then
    alias rm="rm -I"
fi

alias grepn="grep -s -I -n --color=auto"

#NOTE this overrides an existing linux command called open
alias open="file_open"

# Example usage: grep "Some string" * && alert "Message"
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

alias pylint="pylint --rcfile ~/.pylintrc"

# Add colors for filetype and human-readable sizes
if [ "$(uname -s)" == "Darwin" ]; then
    alias ls="ls -G"
else
    alias ls="ls --color=auto -h"
fi
alias la="ls -A"
alias lx="ls -lXB" # Sort by extension
alias lk="ls -lSr" # Sort by size, biggest last
alias lt="ls -ltr" # Sort by date, most recent last
alias lc="ls -ltcr" # Sort by/show change time, most recent last
alias lu="ls -ltur" # Sort by/show access time, most recent last

alias ll="ls -alF"

# }}}

# Shortcuts {{{
alias vbrc="vim ~/.bashrc && source ~/.bashrc"
alias back="cd - > /dev/null"
alias h="history | grep"
alias reload="source ~/.bashrc"
alias realias="$EDITOR ~/.bash_aliases; source ~/.bash_aliases"
alias kaenv="source ~/.virtualenv/khan27/bin/activate"
# }}}

# Package Management {{{
alias install="sudo apt-get install"
alias remove="sudo apt-get remove"
# }}}

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

alias mnemosyne='mnemosyne -d ~/Mnemosyne-2.3.5/mnemosyne'

# vim:foldmethod=marker:foldlevel=0
