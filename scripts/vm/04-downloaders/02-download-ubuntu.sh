#!/bin/bash


if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi

CUR_USER=$(whoami)
mkdir -p /home/$CUR_USER/vm/os

if [ -e "/home/$CUR_USER/vm/os/ubuntu-22.04.2-desktop-amd64.iso" ]; then
  echo "File already exists."
  exit 1
fi

wget --output-document=/home/$CUR_USER/vm/os/ubuntu-22.04.2-desktop-amd64.iso https://releases.ubuntu.com/22.04.2/ubuntu-22.04.2-desktop-amd64.iso

echo "Ubuntu Download Complete"