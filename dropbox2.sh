#!/bin/bash
#set -xv

DROPBOX2=$HOME/Dropbox2
if [ $# -gt 1 ]
then
	DROPBOX2="$1"
	shift
fi

echo "Running dropbox in $DROPBOX2"
#BROKEN - need to support dropbox start -i ### HOME=$DROPBOX2 dropbox.py "$@"
echo "Broken..."
