#!/bin/bash
set -e

source $(dirname $0)/dot_functions.sh

directory_warning

#TODO check for sudo access
copy_notice "z/z.1" "absent"
sudo cp z/z.1 /usr/local/man/man1/
mandb
