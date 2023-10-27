#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script must not be run with root/sudo privileges."
	exit 1
fi

yay -S rtl8812au-dkms-git \
    rtl88x2bu-dkms-git rtl8821au-dkms-git 
