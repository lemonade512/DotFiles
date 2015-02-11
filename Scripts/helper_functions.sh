#!/bin/bash


# In order for the following functions to work properly you must have
# REPOSROOT exported in your .bashrc
# REPOSROOT is the relative path from your home directory to where your
# repositories are kept

RESET="\e[0m"

function show_colors() {
    for code in {0..255}; do
        echo -e "\e[38;05;${code}m $code: Test";
    done
}

function color() {
    # Function can be passed a number between 1 and 255 and will return the escape
    # sequence for that terminal color.
    #TODO add support for RGB values
    # Run show_colors to show available colors
    if [[ $1 > 255 || $1 < 1 ]]; then
        echoerr -e "\e[38;05;196mERROR$RESET: Color must be number between 1 and 255."
        return 1
    fi

    echo "\e[38;05;$1m"
}

function verify_ready() {
    if [[ -z $REPOSROOT ]]; then
        echoerr -e "$(color 196)ERROR$RESET: REPOSROOT must be exported in your .bashrc"
        return 1
    fi
}

function echoerr() {
	echo "$@" 1>&2
}

function exiterr() {
    # Exits with $1 error message and $2 error code
    echoerr -e "$(color 196)ERROR$RESET: $1"
    exit $2
}

function confirm() {
    read -p "$1" -n 1 -r
    echo    # (optional) move to a new line
    if [[ ! $REPLY =~ ^[Yy]$ ]]
    then
        exit 1
    fi
}

function find_current_repo() {
    local cwd=`pwd`
    local upstr
    upstr=$(upstr $(basename $REPOSROOT) 2> /dev/null || exit 1)
    if [[ $? > 0 ]]; then
		echoerr -e "$(color 196)ERROR$RESET: Could not find $REPOSROOT"
        return 1
    fi

    local regex="$upstr/[-_a-z]+/?"
    if [[ $cwd =~ $regex ]]; then
        repo="${BASH_REMATCH[0]}"
        echo $repo
        return 0
    else
		echoerr -e "$(color 196)ERROR$RESET: Could not find repository."
        return 1
    fi
}

function up() {
    dir=""
    if [ -z "$1" ]; then
        dir=..
    elif [[ $1 =~ ^[0-9]+$ ]]; then
        x=0
        while [ $x -lt ${1:-1} ]; do
            dir=${dir}../
            x=$(($x+1))
        done
    else
        dir=${PWD%/$1/*}/$1
    fi
    cd "$dir"
}

function upstr() {
    local dir
    dir=$(up "$1" && pwd)
    if [[ $? > 0 ]]; then
        return 1
    fi
    echo "$dir"
}

