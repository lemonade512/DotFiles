#!/bin/bash
set -e

source $(dirname $0)/dot_functions.sh

directory_warning

for dotfile in $(./bin/file_list.sh); do
    dotfiles_path="$PWD/$dotfile"
    path="$HOME/$dotfile"

    if [ -L $path ]; then # Symlink?
        if [ $dotfiles_path = "$(readlink $path)" ]; then #SymLinked Here?
            remove_notice $dotfile "exists"
            unlink $path
        else
            skip_notice $dotfile "external"
        fi
    else
        skip_notice $dotfile "unlinked"
    fi
done

for file in $(find custom -type f -not -name '*README*'); do
    path=$(file/"custom"/$HOME)
    name=$(basename $file)

    if [ -L $path ]; then
        if [ $PWD/$file = $(readlink $path) ]; then
            remove_notice $name "exists"
            unlink $path
        else
            skip_notice "external"
        fi
    else
        skip_notice $name "unlinked"
    fi
done
