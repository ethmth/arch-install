#!/bin/bash

OS_VERSION="21.1"

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi

CUR_USER=$(whoami)
mkdir -p /home/$CUR_USER/vm/os

if [ -e "/home/$CUR_USER/vm/os/linuxmint-$OS_VERSION-xfce-64bit.iso" ]; then
  echo "File already exists."
  exit 1
fi

wget --output-document=/home/$CUR_USER/vm/os/linuxmint-$OS_VERSION-xfce-64bit.iso https://mirrors.advancedhosters.com/linuxmint/isos/stable/$OS_VERSION/linuxmint-$OS_VERSION-xfce-64bit.iso

echo "Mint Download Complete"