#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
        echo "This script should not be run with root/sudo privileges."
        exit 1
fi

CUR_USER=$(whoami)

if ! [ -e "env.conf" ]; then
	echo "Make sure you run this script in the same directory as env.conf"
	exit 1
fi

LOC=$(lsblk --noheadings -o MOUNTPOINTS | grep -v '^$' | grep -v "/boot" | fzf --prompt="Select your desired SD installation location")

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

git clone --depth 1 https://github.com/oobabooga/text-generation-webui.git $LOC/text-generation-webui

# ln -s $LOC/text-generation-webui/docker/{Dockerfile,docker-compose.yml,.dockerignore} $LOC/text-generation-webui
cp -r $LOC/text-generation-webui/docker/. $LOC/text-generation-webui
cp env.conf $LOC/text-generation-webui/.env

echo "text-generation-webui installed to $LOC. Run 'docker compose up --build' to start"
echo "text-generation-webui will run on port 7859"
echo "cd $LOC/text-generation-webui"
