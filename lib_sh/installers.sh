#!/usr/bin/env bash

###
# Convenience methods for requiring installed software
###

source $__root/lib_sh/echos.sh

NVM_URL="https://raw.githubusercontent.com/creationix/nvm/v0.33.0/install.sh"

function source_nvm() {
    export NVM_DIR="$HOME/.nvm"
    if [ -s "$NVM_DIR/nvm.sh" ]; then
        source $NVM_DIR/nvm.sh
    else
        source $(brew --prefix nvm)/nvm.sh
    fi
}

function require_brew() {
    running "brew install $1"
    brew list $1 > /dev/null 2>&1 | true
    if [[ ${PIPESTATUS[0]} != 0 ]]; then
        brew install $1 > /dev/null 2>&1
        if [[ $? != 0 ]]; then
            error
        fi
    fi
    ok
}

function install_nvm() {
    running "installing nvm from Github"
    if [[ ! -d "$HOME/.nvm" ]]; then
        curl -o- "$NVM_URL" 2>/dev/null | bash > /dev/null 2>&1
        source_nvm
        nvm --version > /dev/null 2>&1
        if [[ $? != 0 ]]; then
            error
            return
        fi
    fi
    ok
}

function require_nvm() {
    source_nvm
    running "nvm install $1"
    nvm ls $1 > /dev/null 2>&1
    if [[ $? != 0 ]]; then
        mkdir -p ~/.nvm
        nvm install $1 > /dev/null 2>&1
        if [[ $? != 0 ]]; then
            error
            return
        fi
    fi
    ok
}

function require_npm() {
    source_nvm
    nvm use stable
    running "npm install -g $1"
    npm list -g --depth 0 | grep "$1" > /dev/null 2>&1
    if [[ $? != 0 ]]; then
        npm install -g "$1" > /dev/null 2>&1
        if [[ $? != 0 ]]; then
            error
            return
        fi
    fi
    ok
}

function require_apt() {
    running "apt-get install $1"
    dpkg -l $1 > /dev/null 2>&1 | true
    if [[ ${PIPESTATUS[0]} != 0 ]]; then
        sudo apt-get install -y $1 > /dev/null 2>&1
        if [[ $? != 0 ]]; then
            error
            return
        fi
    fi
    ok
}

function install_pyenv() {
    running "Installing pyenv from Github"
    if [ ! -d "~/.pyenv" ]; then
        git clone https://github.com/pyenv/pyenv.git ~/.pyenv > /dev/null 2>&1
        git clone https://github.com/pyenv/pyenv-virtualenv.git $(pyenv root)/plugins/pyenv-virtualenv > /dev/null 2>&1
        source $__root/homedir/.bashrc
    fi
    ok
}

function require_pyenv() {
    # Setup required virtual environment using pyenv
    #   $1 - The python version for this environment
    #   $2 - The name of the virtual environment
    running "pyenv virtualenv $1 $2"
    pyenv versions | grep $1 > /dev/null 2>&1
    if [[ $? != 0 ]]; then
        pyenv install $1 > /dev/null 2>&1
        if [[ $? != 0 ]]; then
            error
            return
        fi
    fi

    pyenv versions | grep $2 > /dev/null 2>&1
    if [[ $? != 0 ]]; then
        pyenv virtualenv $1 $2 > /dev/null 2>&1
        if [[ $? != 0 ]]; then
            error
            return
        fi
    fi
    ok
}

function require_pip() {
    running "pip install $1"
    sudo pip show $1 > /dev/null 2>&1
    if [[ $? != 0 ]]; then
        sudo pip install "$1" > /dev/null 2>&1
        if [[ $? != 0 ]]; then
            error
            return
        fi
    fi
    ok
}

function upgrade_pip() {
    running "pip install --upgrade $1"
    sudo pip install --upgrade $1 > /dev/null 2>&1
    if [[ $? != 0 ]]; then
        error
        return
    fi
    ok
}

function default_shell() {
    # Changes the default login shell
    #   $1 - Desired default shell
    running "chsh -s `which $1` `whoami`"
    sudo chsh -s `which $1` `whoami`
    ok
}
