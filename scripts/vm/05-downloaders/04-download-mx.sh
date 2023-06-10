#!/bin/bash


if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi

CUR_USER=$(whoami)
mkdir -p /home/$CUR_USER/vm/os

if [ -e "/home/$CUR_USER/vm/os/MX-21.3_KDE_x64.iso" ]; then
  echo "File already exists."
  exit 1
fi

wget --output-document=/home/$CUR_USER/vm/os/MX-21.3_KDE_x64.iso https://sourceforge.net/projects/mx-linux/files/Final/KDE/MX-21.3_KDE_x64.iso/download

echo "MX Linux Download Complete"