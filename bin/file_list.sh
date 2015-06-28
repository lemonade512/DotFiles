#!/usr/bin/env bash
set -e

__dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
__root=$(dirname $__dir)

manualfile="$__root/FILES"

if [ -f $manualfile ]; then
	files="$(cat $manualfile)"
else
	# Get list of files to link
	includes="$__root/.vim $__root/nose.cfg $__root/Scripts $__root/liquidprompt/liquidprompt"
	excludes=".gitignore"
	base="$(find $__root -maxdepth 1 -name '.*' -not -name '.*.local' -not -name '*.swp' -type f \
		    | sed 's#^\./##' | grep -vF $excludes)"
    files="$base $includes"
fi

echo $files
