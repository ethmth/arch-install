#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi

CUR_USER=$(whoami)

# YubiKey rules
sudo cp /home/$CUR_USER/arch-install/files/configs/70-u2f.rules /etc/udev/rules.d/70-u2f.rules
sudo chmod 644 /etc/udev/rules.d/70-u2f.rules