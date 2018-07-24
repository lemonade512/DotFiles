#!/usr/bin/env bash

source $__root/lib_sh/echos.sh

function install_package_managers() {
    install_homebrew
}

function install_homebrew() {
    # Copied from https://github.com/atomantic/dotfiles/blob/master/install.sh

    running "checking homebrew install"
    brew_bin=$(which brew) 2>&1 > /dev/null
    if [[ $? != 0 ]]; then
        action "installing homebrew"
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        if [[ $? != 0 ]]; then
            error "unable to install homebrew, script $0 abort!"
            exit 2
        fi
    else
        ok
        # Make sure we’re using the latest Homebrew
        running "updating homebrew"
        brew update
        ok
        bot "before installing brew packages, we can upgrade any outdated packages."
        ask "run brew upgrade? [y|N] " response
        if [[ $response =~ ^(y|yes|Y) ]];then
            # Upgrade any already-installed formulae
            action "upgrade brew packages..."
            brew upgrade
            ok "brews updated..."
        else
            ok "skipped brew package upgrades.";
        fi
    fi
}
