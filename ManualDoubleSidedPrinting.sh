#!/bin/sh

# Utility for manually printing double sided document using printer


if [ "$#" -ne 1 ]
then
    echo "ERROR: Invalid number of arguments!" >&2
    exit 1
fi

if [ ! -f "$1" ]
then
    echo "ERROR: File does not exist or is not a regular file!" >&2
    exit 1
fi

lpr -o page-set=odd "$1"

NUM_OF_PAGES="$(mdls -name kMDItemNumberOfPages -raw $1)"
if [ `expr $NUM_OF_PAGES % 2` == 0 ]
then
    echo "Please turn the printed pages over and load them into the printer paper tray."
else
    echo "Attention! The number of printed pages is odd. Please remove the last page that was printed from the batch and load the rest into the printer paper tray."
fi

echo "Continue? (y/n)? "
old_stty_cfg=$(stty -g)
stty raw -echo
answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
stty $old_stty_cfg
if echo "$answer" | grep -iq "^y" ;then
    lpr -o page-set=even -o outputorder=reverse "$1"
else
    exit 2
fi

exit 0

