# vim:foldmethod=marker:foldlevel=0

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Basic directory configuration
CONFIG_DIR="$HOME/.config"

# Make sure .bashrc is idempotent
[[ -z "$PATH_ORIGINAL" ]] && export PATH_ORIGINAL=$PATH
export PATH=$PATH_ORIGINAL:$HOME/bin
export PATH=$PATH:$HOME/libraries/google_appengine/
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:/opt/mssql-tools/bin
export PATH=$PATH:$HOME/arcanist/bin
export PATH="$HOME/.pyenv/bin:$PATH"

# Initialize pyenv
if [ $(command -v pyenv) ]; then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi

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

# Custom Prompt {{{

# NOTE this MUST come before the custom definition sourcing because otherwise the prompt is screwed up when you deactivate
#      the khan academy virtual environment

# Reset PROMPT COMMAND so sourcing this file is idempotent
PROMPT_COMMAND=""
PS1="\n${HC}[ ${RS}${FRED}\u@\h ${RS}${HC}] ${HC}${FGRN}\w${RS}\n${HC}${FRED}\$${RS} "
if [ -f  ~/liquidprompt ]; then
    source ~/liquidprompt
fi

if [ -e "$HOME/DotFiles/z/z.sh" ]; then
    . "$HOME/DotFiles/z/z.sh"
fi
# Make terminal title reflect current directory
#PROMPT_COMMAND=$PROMPT_COMMAND'echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'

# }}}

# Source custom definitions {{{

if [ -s ~/.bashrc.khan ]; then
    . ~/.bashrc.khan
fi

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if [ -f ~/.bash_functions ]; then
	. ~/.bash_functions
fi

## enable color support of ls
#if [ -x /usr/bin/dircolors ]; then
#    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
#fi

# better LS colors
export LS_COLORS="di=1;34:ln=35:so=31:pi=33:ex=32:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"


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
#shopt -s globstar

# correct minor errors in 'cd' commands
shopt -s cdspell

# Bash command editing works like vi
set -o vi

if [ "$(uname -s)" != "Darwin" ]; then
    export EDITOR="/usr/bin/vim"
else
    export EDITOR="/Applications/MacVim.app/Contents/MacOS/Vim"
fi
if [[ $TERM == xterm ]]; then
    TERM=xterm-256color
fi

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

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

# Google Tools {{{
# The next line updates PATH for the Google Cloud SDK.
if [ -f /home/phillip/libraries/google-cloud-sdk/path.bash.inc ]; then
  source '/home/phillip/libraries/google-cloud-sdk/path.bash.inc'
fi

# The next line enables shell command completion for gcloud.
if [ -f /home/phillip/libraries/google-cloud-sdk/completion.bash.inc ]; then
  source '/home/phillip/libraries/google-cloud-sdk/completion.bash.inc'
fi
# }}}

# NVM {{{
if [ ! -d $CONFIG_DIR/dotfiles ]; then
    mkdir -p $CONFIG_DIR/dotfiles
fi

# Cache the directory for nvm. Before, we were just calling `brew --prefix nvm`
# every time we needed this information, but that would take a few seconds.
if [ -e $CONFIG_DIR/dotfiles/nvmbin ]; then
    NVM_BIN=$(cat $CONFIG_DIR/dotfiles/nvmbin)
fi

if [ ! -e "$NVM_BIN" ] || [ -z "$NVM_BIN" ]; then
    NVM_BIN=$(brew --prefix nvm)
    echo "$NVM_BIN" > $CONFIG_DIR/dotfiles/nvmbin
fi

export NVM_DIR="$HOME/.nvm"
if [ "$(uname)" == "Darwin" ]; then
    [ -s "$NVM_BIN/nvm.sh" ] && source $NVM_BIN/nvm.sh
else
    [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
fi
# }}}
