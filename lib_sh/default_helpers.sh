#!/usr/bin/env bash

###############################################################################
# This file contains all of the default implementations of the helper
# functions used in the install script. If you need platform-specific
# functionality, add it to the respective helpers bash script. For example,
# MacOS functionality is located in macos_helpers.sh.
###############################################################################

source $__root/lib_sh/installers.sh

function get_full_name() {
    # TODO (plemons): Implement this
    :
}

function get_email() {
    # TODO (plemons): Implement this
    :
}

function install_package_managers() {
    # TODO (plemons): Implement this
    :
}

function install_development_tools() {
    # TODO (plemons): Implement this
    :
}

function create_symlinks() {
    now=$(date "+%Y.%m.%d.%H.%M.%S")

    action "Installing top-level dotfiles"
    for file in $(find $__root/homedir -maxdepth 1 -mindepth 1); do
        running "linking $(basename $file)"
        target="$HOME/$(basename $file)"
        if [[ -e "$target" ]]; then
            mkdir -p ~/.dotfiles_backup/$now
            mv "$target" ~/.dotfiles_backup/$now/$(basename $file)
        fi
        # symlink might still exist
        unlink $target > /dev/null 2>&1
        # create link
        ln -s $file $target
        ok
    done

    action "Installing .config dotfiles"
    if [ ! -d "$HOME/.config" ]; then
        running "mkdir -p ~/.config"
        mkdir -p $HOME/.config
    fi
    config_files=$( find "$__root/config" -maxdepth 1 -mindepth 1 2>/dev/null )
    for file in $config_files; do
        # TODO (plemons): This for loop and the one used for the regular
        # dotfiles are almost the same. Refactor into shared function?
        running "linking $(basename $file)"
        target="$HOME/.config/$( basename "$file" )"
        if [[ -e "$target" ]]; then
            mkdir -p ~/.dotfiles_backup/$now
            mv "$target" ~/.dotfiles_backup/$now/$(basename $file)
        fi
        unlink $target > /dev/null 2>&1
        ln -s "$file" "$target"
        ok
    done

    # TODO (plemons): Make sure we backup liquidprompt if it exists
    action "Installing liquidprompt"
    running "Linking $__root/liquidprompt/liquidprompt"
    ln -s "$__root/liquidprompt/liquidprompt" "$HOME/liquidprompt" > /dev/null 2>&1
    ok
}

function setup_neovim() {
    running "Installing nvim plugins..."
    nvim +PlugInstall +qall > /dev/null 2>&1
    if [[ $? != 0 ]]; then
        error
    else
        ok
    fi
    require_pyenv 2.7.15 neovim2
    require_pyenv 3.6.6 neovim3

    require_pip 'python_language_server'
    require_pip 'rope'
    require_pip 'pyflakes'
    require_pip 'mccabe'
    require_pip 'pycodestyle'
    require_pip 'pydocstyle'
    require_pip 'autopep8'
    require_pip 'yapf'
    require_npm 'bash-language-server'

    # Initialize pyenv and pyenv virtualenv
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"

    pyenv activate neovim2 > /dev/null 2>&1
    echo -en "(neovim2) "; require_pip neovim
    python2_path=`pyenv which python`

    pyenv activate neovim3 > /dev/null 2>&1
    echo -en "(neovim3) "; require_pip neovim
    python3_path=`pyenv which python`
    pyenv deactivate

    running "Adding python paths to nvim config"
    sed -r -i "s#(\s*let g:python_host_prog\s*=\s*).*#\1'$python2_path'#" $__root/config/nvim/init.vim > /dev/null 2>&1
    if [[ $? != 0 ]]; then
        running "compensating for MacOS"
        sed -E -i '' "s#([[:space:]]*let g:python_host_prog[[:space:]]*=[[:space:]]*).*#\1'$python2_path'#" $__root/config/nvim/init.vim
        sed -E -i '' "s#([[:space:]]*let g:python3_host_prog[[:space:]]*=[[:space:]]*).*#\1'$python3_path'#" $__root/config/nvim/init.vim
    else
        sed -r -i "s#(\s*let g:python3_host_prog\s*=\s*).*#\1'$python3_path'#" $__root/config/nvim/init.vim
    fi
    ok
}

function setup_oh_my_zsh() {
    action "Installing oh my zsh"
    running "Linking $__root/oh-my-zsh"
    ln -s "$__root/oh-my-zsh" "$HOME/.oh-my-zsh" > /dev/null 2>&1
    ok

    # TODO (plemons): There are a lot of things that get installed from
    # Github via a git clone. Perhaps we should just add a require_github
    # function in the installers.sh file?
    running "Installing powerlevel9k from Github"
    if [[ ! -d "$__root/oh-my-zsh/custom/themes/powerlevel9k" ]]; then
        git clone https://github.com/bhilburn/powerlevel9k.git $__root/oh-my-zsh/custom/themes/powerlevel9k > /dev/null 2>&1
    fi
    ok

    running "Installing autosugestions from Github"
    if [[ ! -d "$__root/oh-my-zsh/custom/plugins/zsh-autosuggestions" ]]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions $__root/oh-my-zsh/custom/plugins/zsh-autosuggestions > /dev/null 2>&1
    fi
    ok
}
