#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi

CUR_USER=$(whoami)

sudo sh -c "echo '%wheel ALL=(ALL:ALL) NOPASSWD: ALL' > /etc/sudoers.d/wheel"

if ! grep -q "^wheel:" /etc/group; then
	sudo groupadd wheel
fi
sudo usermod -aG wheel $CUR_USER

groups $CUR_USER

echo "Verify that you were added to the correct groups"