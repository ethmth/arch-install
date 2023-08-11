#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
        echo "This script should not be run with root/sudo privileges."
        exit 1
fi

CUR_USER=$(whoami)

if ! [ -e "docker-compose.yml" ]; then
    echo "Docker compose file not found"
    exit 1
fi
if ! [ -e "Dockerfile" ]; then
    echo "Dockerfile not found"
    exit 1
fi
if ! [ -e "requirements.txt" ]; then
    echo "requirements.txt file not found"
    exit 1
fi

LOC=$(lsblk --noheadings -o MOUNTPOINTS | grep -v '^$' | grep -v "/boot" | fzf --prompt="Select your desired kohya installation location")

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

git clone https://github.com/SortAnon/ControllableTalkNet.git $LOC/ControllableTalkNet
cp docker-compose.yml $LOC/ControllableTalkNet/docker-compose.yml
cp Dockerfile $LOC/ControllableTalkNet/Dockerfile
cp requirements.txt $LOC/ControllableTalkNet/requirements.txt



echo "Docker version installed to $LOC."
echo "Run 'docker compose up --build' to start."
echo "cd $LOC/ControllableTalkNet"

# RUN python3.8 -m pip install protobuf==3.20.3
# RUN python3.8 -m pip install numpy==1.21.6
