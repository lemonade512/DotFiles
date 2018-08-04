#!/usr/bin/env bash

__root=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

source $__root/lib_sh/colors.sh
source $__root/lib_sh/echos.sh

# Source helper functions based on operating system
source $__root/lib_sh/default_helpers.sh
if [ "$(uname)" == "Darwin" ]; then
    source $__root/lib_sh/macos_helpers.sh
elif [ "$(grep -Ei 'debian|buntu|mint' /etc/*release)" ]; then
    source $__root/lib_sh/debian_helpers.sh
fi

# Ask for the administrator password upfront
bot "I need you to enter your sudo password so I can install some things:"
sudo -v

# Keep-alive: update existing sudo time stamp until the script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# TODO (plemons): If I ever change to using Python instead of bash, it would
# be useful to use Jinja templates for things like this.
if [[ ! -e $__root/homedir/.gitconfig ]]; then
    bot "It looks like your .gitconfig file needs some updating"
    running "cp templates/.gitconfig homedir/.gitconfig"
    cp $__root/templates/.gitconfig $__root/homedir
    ok

    fullname=`get_full_name`
    email=`get_email`
    if [[ ! "$fullname" ]]; then
        response='n'
    else
        echo -e "I see that your full name is ${COL_YELLOW}${fullname}${COL_RESET}"
        ask "Is this correct? [Y|n]" response
    fi

    if [[ $response =~ ^(no|n|N) ]];then
        ask "What is your first name? " firstname
        ask "What is your last name? " lastname
        fullname="$firstname $lastname"
    fi

    if [[ ! "$email" ]];then
        response='n'
    else
        echo -e "The best I can make out, your email address is $COL_YELLOW$email$COL_RESET"
        ask "Is this correct? [Y|n] " response
    fi

    if [[ $response =~ ^(no|n|N) ]]; then
        ask "What is your email? " email
        if [[ ! "$email" ]]; then
            error "you must provide an email to configure .gitconfig"
            exit 1
        fi
    fi

    action "Replacing items in .gitconfig with your info (${COL_YELLOW}$fullname, $email${COL_RESET})"

    # Test if gnu-sed or MacOS sed
    sed -i "s/GITFULLNAME/$fullname/" $__root/homedir/.gitconfig > /dev/null 2>&1 | true
    if [[ ${PIPESTATUS[0]} != 0 ]]; then
        action "Looks like you are using MacOS sed rather than gnu-sed, accommodating"
        sed -i '' "s/GITFULLNAME/$fullname/" $__root/homedir/.gitconfig
        sed -i '' "s/GITEMAIL/$email/" $__root/homedir/.gitconfig
    else
        sed -i "s/GITEMAIL/$email/" $__root/homedir/.gitconfig
    fi
fi

bot "Installing package managers"
install_package_managers

bot "Installing development tools"
install_development_tools

bot "Creating symlinks for project dotfiles"
create_symlinks

bot "Neovim"
setup_neovim
