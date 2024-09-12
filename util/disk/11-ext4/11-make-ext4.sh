#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
	echo "This script must be run with root/sudo privileges."
	exit 1
fi

name=$(ls -1 /dev/mapper | grep -v "control" | fzf --prompt="Please select the /dev/mapper device you want to add an fstab entry for.")
mkfs.ext4 /dev/mapper/$name


echo "ext4 partition should have been created for /dev/mapper/$name"
