#!/bin/bash


if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi

CUR_USER=$(whoami)
mkdir -p /home/$CUR_USER/vm/os

if [ -e "/home/$CUR_USER/vm/os/latest-nixos-gnome-x86_64-linux.iso" ]; then
  echo "File already exists."
  exit 1
fi

wget --output-document=/home/$CUR_USER/vm/os/latest-nixos-gnome-x86_64-linux.iso https://channels.nixos.org/nixos-23.05/latest-nixos-gnome-x86_64-linux.iso

echo "NixOS Download Complete"