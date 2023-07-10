#!/bin/bash

NAME="jupyter-lab"

if ! [[ $EUID -ne 0 ]]; then
        echo "This script should not be run with root/sudo privileges."
        exit 1
fi

if ! [ -e "../$NAME/docker-compose.yml" ]; then
	echo "Make sure you run this script in the same directory as ../$NAME/docker-compose.yml"
	exit 1
fi

CUR_USER=$(whoami)

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

LOC="$LOC/programs/$NAME"


mkdir -p $LOC

mkdir -p $LOC/data
chmod -R 777 $LOC/data

cp docker-compose.yml $LOC/docker-compose.yml
cp Dockerfile $LOC/Dockerfile

echo "$NAME installed to $LOC. Run 'docker compose up --build' to start"
echo "$NAME will run on port 8888"
echo "cd $LOC"
