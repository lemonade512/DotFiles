#!/usr/bin/env bash

source $__root/lib_sh/requirers.sh

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
    require_apt build-essential
    require_apt neovim
    require_apt net-tools
    require_apt nmap
    require_apt tmux
    require_apt tree
    require_pip virtualenv
    require_apt wget
}
