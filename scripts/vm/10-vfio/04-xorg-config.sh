#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi

CUR_USER=$(whoami)
source /home/$CUR_USER/arch-install/config/system.conf

read -p "Do you want to use a Nvidia GPU on the host (y/N)? " userInput

if ! ([ "$userInput" == "Y" ] || [ "$userInput" == "y" ]); then
    echo "Nvidia host GPU not selected, no action taken"
    exit 0
fi

sudo nvidia-xconfig

sudo mv /etc/X11/xorg.conf /etc/X11/xorg.conf.d/10-nvidia.conf