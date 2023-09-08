#!/bin/bash

NAME="coverlettergpt"

if ! [[ $EUID -ne 0 ]]; then
        echo "This script should not be run with root/sudo privileges."
        exit 1
fi

CUR_USER=$(whoami)

LOC="/home/$CUR_USER/programs"

cd $LOC/$NAME

wasp start db

wasp db migrate-dev

echo "Now, go to $LOC/$NAME and run 'wasp start'"