#!/usr/bin/env bash

set -e

__dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
__root=$(dirname $__dir)

source $__dir/dot_functions.sh

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit
fi

if [ ! -e "/usr/local/man/man1" ]; then
    copy_notice "z/z.1 -> /usr/local/man/man1" "absent"
    sudo cp z/z.1 /usr/local/man/man1/
    mandb
else
    skip_notice "/usr/local/man/man1" "exists"
fi
