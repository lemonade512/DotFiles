#!/usr/bin/env bash

source $__root/lib_sh/echos.sh
source $__root/lib_sh/installers.sh

function get_full_name() {
    fullname=`osascript -e "long user name of (system info)"`
    if [[ -n "$fullname" ]];then
        lastname=$(echo $fullname | awk '{print $2}');
        firstname=$(echo $fullname | awk '{print $1}');
    fi

    if [[ -z $lastname ]]; then
        lastname=`dscl . -read /Users/$(whoami) | grep LastName | sed "s/LastName: //"`
    fi
    if [[ -z $firstname ]]; then
        firstname=`dscl . -read /Users/$(whoami) | grep FirstName | sed "s/FirstName: //"`
    fi
    fullname="$firstname $lastname"
    echo "$fullname"
}

function get_email() {
    echo `dscl . -read /Users/$(whoami)  | grep EMailAddress | sed "s/EMailAddress: //"`
}

function install_package_managers() {
    install_homebrew
    require_brew nvm
    require_nvm stable
    require_nvm node
    install_pyenv
}

function install_homebrew() {
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
        brew update > /dev/null 2>&1
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

function install_development_tools() {
    require_brew docker
    require_brew git
    require_brew neovim
    require_brew nmap
    require_brew tmux
    require_brew tree
    require_brew wget
}
