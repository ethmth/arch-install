#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
	echo "This script must be run with root/sudo privileges."
	exit 1
fi

disksuffix=$(lsblk --list | grep -E "disk|part" | fzf --prompt="Select disk or partition to encrypt" | cut -d' ' -f1)
if [ "$disksuffix" == "" ]; then
    echo "Nothing selected. Nothing done."
    exit 1
fi
disk="/dev/$disksuffix"

read -p "Are you sure you want to format $disk (YES for yes, otherwise No)? " userInput

if ! [ "$userInput" == "YES" ]; then
    echo "Cancelling. No damage done."
    exit 1
fi

echo "Encryption setup for filesystem:"
cryptsetup -c aes-xts-plain64 -h sha512 -s 512 luksFormat "$disk"

echo "Disk encrypted. Open the disk with:"

echo "cryptsetup luksOpen $disk <NAME>"

echo "Optionally, run the add-disk.sh script to add it to /etc/crypttab."