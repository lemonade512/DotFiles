#!/usr/bin/env bash

set -e

source $(dirname $0)/dot_functions.sh

BACKUP_DIR="$HOME/backup"

function link_file() {
    # $1 = path to dotfile
    # $2 = path to link
    if [ ! -e $2 ]; then
        link_notice "$1 -> $2" "absent"
        ln -nfs $1 $2
    else
        if [ $backup = true ] && [ ! $1 = "$(readlink $2)" ]; then
            backup_notice "$1" "$BACKUP_DIR"
            if [ ! -e $BACKUP_DIR ]; then
                mkdir -p $BACKUP_DIR
            fi
            mv $2 $BACKUP_DIR
            link_notice "$1 -> $2" "backed up"
            ln -nfs $1 $2
        else
            skip_notice $2 "exists"
        fi
    fi
}

# Make sure we are in the proper directory
directory_warning

backup=true
if [ $# -ne 0 ]; then
    if [[ "$1" == "--no-backup" ]]; then
        backup=false
    fi
fi

for dotfile in $(./bin/file_list.sh); do
    dotfiles_path="$PWD/$dotfile"
    path="$HOME/$(basename $dotfile)"

    [ -e $dotfiles_path ] || continue
    link_file $dotfiles_path $path $dotfile
done


for file in $(find custom -type f -not -name '*README*'); do
    # in file substitute "custom" with the value of $HOME (like vim s/from/to/g)
    path=${file/"custom"/$HOME}

    if [ ! -L $path ]; then
        dest=$(dirname $path)
        link_notice "$file -> $path" "absent"
        mkdir -p $dest
        ln -nfs $PWD/$file $dest
    else
        skip_notice $path "exists"
    fi
done
