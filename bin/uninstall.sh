#!/usr/bin/env bash

set -e

__dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
__root=$(dirname $__dir)

source $__dir/dot_functions.sh

for dotfile in $($__dir/file_list.sh); do
    path="$HOME/$(basename $dotfile)"

    if [ ! "$dotfile" = "$(readlink -f $dotfile)" ]; then
        dotfile=$__root/$dotfile
    fi

    if [ -L $path ]; then # Symlink?
        if [ $dotfile = "$(readlink $path)" ]; then #SymLinked Here?
            remove_notice $path "exists"
            unlink $path
        else
            echo "dotfile="$dotfile
            echo "path=$path"
            echo "readlink path="$(readlink $path)
            skip_notice $path "external"
        fi
    else
        skip_notice $path "unlinked"
    fi
done

for file in $(find $__root/custom -type f -not -name '*README*'); do
    path=${file/"DotFiles/custom/"/}

    if [ -L $path ]; then
        if [ $file = $(readlink $path) ]; then
            remove_notice $path "exists"
            unlink $path
        else
            skip_notice $path "external"
        fi
    else
        skip_notice $path "unlinked"
    fi
done
