#!/usr/bin/env bash

source $__root/lib_sh/installers.sh

function get_full_name() {
    # Gotten from https://ubuntuforums.org/showthread.php?t=865585
    echo `getent passwd $USER | cut -d ":" -f 5 | cut -d "," -f 1`
}

function install_package_managers() {
    install_nvm
    require_nvm node
    require_apt python-pip
    upgrade_pip pip
}

function install_development_tools() {
    action "Install pyenv dependencies"
    require_apt curl
    require_apt libbz2-dev
    require_apt libncurses5-dev
    require_apt libreadline-dev
    require_apt libsqlite3-dev
    require_apt libssl-dev
    require_apt llvm
    require_apt make
    require_apt tk-dev
    require_apt xz-utils
    require_apt zlib1g-dev

    action "Install general-purpose tools"
    require_apt build-essential
    require_apt neovim
    require_apt net-tools
    require_apt nmap
    require_apt tmux
    require_apt tree
    require_pip virtualenv
    require_apt wget
    install_pyenv

    action "Installing zsh"
    require_apt zsh
    default_shell zsh
}
