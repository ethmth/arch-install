#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
	echo "This script must be run with root/sudo privileges."
	exit 1
fi

echo "This is the command I ran:"
echo "mkfs.btrfs -s 4096 -d raid1 -m raid1 /dev/mapper/cryptext1 /dev/mapper/cryptext2"