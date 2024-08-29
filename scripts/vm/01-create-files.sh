#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi

CUR_USER=$(whoami)

mkdir -p /home/$CUR_USER/vm/os

if ! [ -f "/home/$CUR_USER/vm/os/NOISO.iso" ]; then
    dd if=/dev/zero of=/home/$CUR_USER/vm/os/NOISO.iso bs=1M count=1
fi