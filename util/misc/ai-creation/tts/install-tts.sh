#!/bin/bash

NAME="tts"

if ! [[ $EUID -ne 0 ]]; then
        echo "This script should not be run with root/sudo privileges."
        exit 1
fi

CUR_USER=$(whoami)

if ! [ -e "docker-compose.yml" ]; then
    echo "Docker compose file not found"
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

DISK=$LOC
LOC="$LOC/programs"
mkdir -p $LOC

git clone https://github.com/coqui-ai/TTS.git $LOC/$NAME
cp docker-compose.yml $LOC/$NAME/docker-compose.yml

echo "Docker version installed to $LOC."
echo "Run 'docker compose up --build' to start."
echo "cd $LOC/$NAME"
