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
# mkdir -p $LOC
mkdir -p $LOC/stable-diffusion-webui

read -p "Do you need to use prime-run for an Nvidia GPU (Y for Yes, otherwise No)? " primeStr

PRIME=0
if ([ "$primeStr" == "Y" ] || [ "$primeStr" == "y"]); then
    PRIME=1
fi

# pyenv shell 3.10

git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git $LOC/stable-diffusion-webui
# wget -q -O $LOC/stable-diffusion-webui/webui.sh https://raw.githubusercontent.com/AUTOMATIC1111/stable-diffusion-webui/master/webui.sh

sed -i 's/python_cmd="python3"/python_cmd="python3.10"/g' $LOC/stable-diffusion-webui/webui.sh

cd $LOC
if (( PRIME )); then
    # bash prime-run <(wget -qO- https://raw.githubusercontent.com/AUTOMATIC1111/stable-diffusion-webui/master/webui.sh) --skip-torch-cuda-test
    bash prime-run stable-diffusion-webui/webui.sh
else
    # bash <(wget -qO- https://raw.githubusercontent.com/AUTOMATIC1111/stable-diffusion-webui/master/webui.sh) --skip-torch-cuda-test
    bash stable-diffusion-webui/webui.sh
fi