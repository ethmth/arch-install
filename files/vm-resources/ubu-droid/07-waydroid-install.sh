#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
        echo "This script should not be run with root/sudo privileges."
        exit 1
fi

curl https://repo.waydro.id | sudo bash

sudo apt install waydroid -y

echo "Now, run ./08-package-install.sh and ./09-waydroid-init simultaneously"