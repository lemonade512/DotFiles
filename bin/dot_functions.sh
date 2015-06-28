#!/usr/bin/env bash

# Colors

red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
normal=$(tput sgr0)

# Print functions

print_padded() {
    # The goal of this function is to take in something to print as the first option,
    # the status as teh second option, and the status color as the third option. The
    # status will then be printed such that the distance between brackets [] will be a
    # multiple of 10 and there will always be at least 1 space on either end of the
    # status. There are probably better ways to make this look good for longer statuses
    # but this works for what I want for now. TODO (phillip) I should write a better
    # function for printing statuses to the command line.
	local len=${#2}

    # To round up use add (denom-1) to the numerator as described here
    # http://stackoverflow.com/questions/2395284/round-a-divided-number-in-bash
    local mult=$(((len + 9) / 10))
	printf "%-100s [$3%$((len+((mult*10)-len)/2))s%$((((mult*10)-len)/2))s$normal]\n" "$1" "$2"
}

create_notice() {
	print_padded "Creating $1" "$2" $green
}

skip_notice() {
	print_padded "${yellow}Skipping${normal} $1" "$2" $yellow
}

backup_notice() {
	print_padded "${yellow}Backing Up${normal} $1" "$2" $yellow
}

copy_notice() {
	print_padded "${green}Copying${normal}  $1" "$2" $green
}

link_notice() {
	print_padded "${green}Linking${normal}  $1" "$2" $green
}

remove_notice() {
	print_padded "${red}Removing${normal} $1" "$2" $red
}

# Other functions

dirty_warning() {
	if [ -n "$(git -C $__root status --porcelain)" ]; then
		echo "${red}ERROR: You have a dirty working copy.${normal}"
		echo "Commit or clean any changes, and run $0 again."
		exit 1
	fi
}
