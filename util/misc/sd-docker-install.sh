#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
        echo "This script should not be run with root/sudo privileges."
        exit 1
fi

CUR_USER=$(whoami)

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

# read -p "Do you need to use prime-run for an Nvidia GPU (Y for Yes, otherwise No)? " primeStr

# PRIME=0
# if ([ "$primeStr" == "Y" ] || [ "$primeStr" == "y"]); then
#     PRIME=1
# fi

git clone https://github.com/AbdBarho/stable-diffusion-webui-docker.git $LOC/stable-diffusion-webui-docker

docker compose --project-directory $LOC/stable-diffusion-webui-docker --profile download up --build