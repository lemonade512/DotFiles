# vim:foldmethod=marker:foldlevel=0

# Updating the PATH {{{
# Make sure .bashrc is idempotent
[[ -z "$PATH_ORIGINAL" ]] && export PATH_ORIGINAL=$PATH
export PATH=$PATH_ORIGINAL:$HOME/bin
export PATH=$PATH:$HOME/libraries/google_appengine/
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:/opt/mssql-tools/bin
export PATH=$PATH:$HOME/arcanist/bin
export PATH="$HOME/.pyenv/bin:$PATH"

# Make sure pdflatex is available on Mac (requires `brew cask install mactex`)
export PATH=$PATH:/Library/TeX/texbin
# }}}

# Source oh-my-zsh {{{
# This needs to be sourced before oh-my-zsh
if [ -f "$HOME/.zsh/zsh_theme" ]; then
    source $HOME/.zsh/zsh_theme
fi

export ZSH=$HOME/.oh-my-zsh
plugins=(zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh
# }}}

# Source custom config files {{{
if [ -f "$HOME/.zsh/zsh_alias" ]; then
    source $HOME/.zsh/zsh_alias
fi

if [ -f "$HOME/.zsh/zsh_functions" ]; then
    source $HOME/.zsh/zsh_functions
fi

if [ -f "$HOME/.zsh/zsh_completion" ]; then
    source $HOME/.zsh/zsh_completion
fi

if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then
    source $HOME/google-cloud-sdk/completion.zsh.inc
fi

if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then
    source $HOME/google-cloud-sdk/path.zsh.inc
fi
# }}}

# Initialize pyenv
if [ $(command -v pyenv) ]; then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=245'
export EDITOR="$(which nvim)"

bindkey -v
bindkey '^ ' autosuggest-accept
