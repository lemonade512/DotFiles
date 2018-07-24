#!/usr/bin/env bash

source $__root/lib_sh/colors.sh

function ask() {
    read -r -p "$1 " $2
}

function bot() {
    echo -e "\n${COL_GREEN}\[._.]/${COL_RESET} - "$1
}

function ok() {
    echo -e "${COL_GREEN}[ok]${COL_RESET} $1"
}

function running() {
    #echo -en "${COL_YELLOW} ⇒ ${COL_RESET}$1..."
    echo -en "$1..."
}

function action() {
    echo -e "\n${COL_YELLOW} ⇒ ${COL_RESET}$1..."
}

function error() {
    echo -e "${COL_RED}[error]${COL_RESET} $1"
}

