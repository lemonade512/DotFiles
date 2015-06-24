#!/bin/bash
set -e

source $(dirname $0)/dot_functions.sh

function link_file() {
    if [ ! -e $2 ]; then
        link_notice $3 "absent"
        ln -nfs $1 $2
    else
        if [ $backup = true ] && [ ! $1 = "$(readlink $2)" ]; then
            backup_notice $3 "$backup_dir"
            if [ ! -e $backup_dir ]; then
                mkdir -p $backup_dir
            fi
            mv $2 $backup_dir
            link_notice $3 "backed up"
            ln -nfs $1 $2
        else
            skip_notice $3 "exists"
        fi
    fi
}

backup_dir="$HOME/backup"

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
    path="$HOME/$dotfile"

    [ -e $dotfiles_path ] || continue
    link_file $dotfiles_path $path $dotfile
done


for file in $(find custom -type f -not -name '*README*'); do
    # in file substitute "custom" with the value of $HOME (like vim s/from/to/g)
    path=${file/"custom"/$HOME}
    name=$(basename $file)

    if [ ! -L $path ]; then
        dest=$(dirname $path)
        link_notice $name "absent"
        mkdir -p $dest
        ln -nfs $PWD/$file $dest
    else
        skip_notice $name "exists"
    fi
done

# TODO this is a hack to get liquid prompt in the correct spot. I need to
#      find a better way to do this
cd liquidprompt
link_file $PWD/liquidprompt $HOME/liquidprompt liquidprompt
cd ..
