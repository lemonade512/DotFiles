#!/usr/bin/env bash
set -e

files=

manualfile="$PWD/FILES"

if [ -f $manualfile ]; then
	files="$(cat $manualfile)"
else
	# Get list of files to link
	includes=".vim nose.cfg Scripts liquidprompt/liquidprompt"
	excludes=".gitignore"
	base="$(find . -maxdepth 1 -name '.*' -not -name '.*.local' -not -name '*.swp' -type f \
		    | sed 's#^\./##' | grep -vF $excludes)"
    files="$base $includes"
fi

echo $files
