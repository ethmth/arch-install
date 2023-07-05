#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
        echo "This script should not be run with root/sudo privileges."
        exit 1
fi

curl https://repo.waydro.id | sudo bash

sudo apt install waydroid -y

sudo systemctl enable waydroid-container

sudo waydroid init

waydroid session start