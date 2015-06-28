#!/usr/bin/env bash

set -e

__dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
__root=$(dirname $__dir)

source $__dir/dot_functions.sh

dirty_warning

git -C $__root pull --rebase
$__dir/uninstall.sh
$__dir/install.sh
