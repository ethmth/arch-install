#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
	echo "This script must be run with root/sudo privileges."
	exit 1
fi

disksuffix=$(fdisk -l | grep "Disk /dev/" | grep -v "loop" | fzf --prompt="Select disk to encrypt" | awk -F'/' '{print $3}' | awk -F':' '{print $1}')
disk="/dev/$disksuffix"

read -p "Are you sure you want to format $disk (YES for yes, otherwise No)? " userInput

if ! [ "$userInput" == "YES" ]; then
    echo "Cancelling. No damage done."
    exit 1
fi

echo "Encryption setup for filesystem:"
cryptsetup -c aes-xts-plain64 -h sha512 -s 512 luksFormat "$disk"

echo "Disk encrypted. Run the add-disk.sh script to add it to /etc/crypttab."