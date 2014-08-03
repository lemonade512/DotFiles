#!/bin/bash
set -e

source $(dirname $0)/dot_functions.sh

backup_dir="$HOME/backup"

directory_warning

for dotfile in $(./bin/file_list.sh); do
	dotfiles_path="$PWD/$dotfile"
	path="$HOME/$dotfile"

	[ -e $dotfiles_path ] || continue

	if [ ! -L $path ]; then
		link_notice $dotfile "absent"
		ln -nfs $dotfiles_path $path
	else
		backup_notice $dotfile "$backup_dir"
		if [ ! -e $backup_dir ]; then
			mkdir -p $backup_dir
		fi
		mv $path $backup_dir
		link_notice $dotfile "backed up"
		ln -nfs $dotfiles_path $path
	fi
done

for file in $(find custom -type f -not -name '*README*'); do
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

#TODO test the script on a new VM
