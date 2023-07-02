#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi

CUR_USER=$(whoami)
sudo -k mkdir -p /sharepoint
mkdir -p /home/$CUR_USER/share
sudo mount -t 9p -o trans=virtio /sharepoint /home/$CUR_USER/share/

sudo nixos-generate-config

echo "/etc/nixos/hardware-configuration.nix should be updated with shared drive"