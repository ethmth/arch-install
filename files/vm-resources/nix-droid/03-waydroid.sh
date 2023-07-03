#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script must not be run with root/sudo privileges."
	exit 1
fi

sudo waydroid init
sudo systemctl enable waydroid-container

echo "Reboot, make sure --user waydroid-session.service is running, then run ./04-waydroid-props.sh"