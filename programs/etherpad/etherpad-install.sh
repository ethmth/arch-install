#!/bin/bash

NAME="etherpad"

if ! [[ $EUID -ne 0 ]]; then
        echo "This script should not be run with root/sudo privileges."
        exit 1
fi

CUR_USER=$(whoami)

if ! [ -e "../$NAME/docker-compose.yml" ]; then
	echo "Make sure you run this script in the same directory as ../$NAME/docker-compose.yml"
	exit 1
fi


LOC=$(lsblk --noheadings -o MOUNTPOINTS | grep -v '^$' | grep -v "/boot" | fzf --prompt="Select your desired $NAME installation location")

if ([ "$LOC" == "" ] || [ "$LOC" == "Cancel" ]); then
    echo "Nothing was selected"
    echo "Run this script again with target drive mounted."
    exit 1
fi

if [ "$LOC" == "/" ]; then
    LOC="/home/$CUR_USER"
fi

if ! [ -d "$LOC" ]; then
    echo "Your location is not available. Is the disk mounted? Do you have access?"
	exit 1
fi

LOC="$LOC/programs"
mkdir -p $LOC

if ! [ -e "$LOC/$NAME" ]; then
mkdir -p $LOC/$NAME
fi

cp docker-compose.yml $LOC/$NAME/docker-compose.yml

cd $LOC/$NAME/

echo "Run 'docker compose up --build -d' to run it and 'docker compose stop' to stop it from that directory"
echo "cd $LOC/$NAME"