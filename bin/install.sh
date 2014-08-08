#!/bin/bash
set -e

source $(dirname $0)/dot_functions.sh

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

	if [ ! -L $path ]; then
		link_notice $dotfile "absent"
		ln -nfs $dotfiles_path $path
	else
		if [ $backup = true ]; then
			backup_notice $dotfile "$backup_dir"
			if [ ! -e $backup_dir ]; then
				mkdir -p $backup_dir
			fi
			mv $path $backup_dir
			link_notice $dotfile "backed up"
			ln -nfs $dotfiles_path $path
		else
			skip_notice $dotfile "exists"
		fi
	fi
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

#TODO test the script on a new VM
