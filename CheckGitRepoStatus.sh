#!/bin/sh

# Utility for checking whether git repositories in specified direcotry are up to date (locally and remotely). 


if [ "$#" -ne 1 ]
then
    echo "ERROR: Invalid number of arguments!" >&2
    exit 1
fi

FILE_TYPE=$(stat -q -f "%HT" $1)
if [ $? -ne 0 ]
then
	echo "ERROR: Stat error!" >&2
	exit 1
fi

if [ ! -d "$1" ]
then
	echo "ERROR: $1 directory does not exist!" >&2
	exit 1
fi

if [ "$FILE_TYPE" != "Directory" ]
then
	echo "$FILE_TYPE"
	echo "ERROR: $1 is not a directory!" >&2
	exit 1
fi

for ENTRY in "$1"/* ; do
	# [[ -d "$ENTRY" && ! -L "$ENTRY" ]]
	if [ ! -d "$ENTRY" ]
	then
		continue
		# DIRRR="$( cd "$( dirname "$ENTRY" )" && pwd )"
		# git rev-parse --is-inside-work-tree
	fi
	
	git -C "$ENTRY" rev-parse >/dev/null 2>/dev/null
	if [ $? -ne 0 ]
	then
		continue
	fi
	
	echo "$(basename $ENTRY): "

	REMOTE_UPSTREAMS=$(git -C $ENTRY remote -v)
	if [ "$REMOTE_UPSTREAMS" == "" ]
	then
		git -C $ENTRY status --short
	else
		git -C $ENTRY fetch >/dev/null 2>/dev/null
		git -C $ENTRY status -sb
	fi

	echo ""
done

exit 0

