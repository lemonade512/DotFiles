export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="powerlevel9k/powerlevel9k"
export LS_COLORS="di=1;34:ln=35:so=31:pi=33:ex=32:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"

plugins=(zsh-autosuggestions)
source ~/.zshtheme
source $ZSH/oh-my-zsh.sh

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=245'

zstyle ':completion:*' completer _complete _correct _approximate
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

bindkey -v
bindkey '^ ' autosuggest-accept
