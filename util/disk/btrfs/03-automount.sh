#!/usr/bin/env bash


if [[ $EUID -ne 0 ]]; then
	echo "This script must be run with root/sudo privileges."
	exit 1
fi

name=$(ls -1 /dev/mapper | grep -v "control" | fzf --prompt="Please select the /dev/mapper device you want to add an fstab entry for.")

read -p "Please the name for the mountpoint: " mountname

read -p "Are you sure you want to mount /dev/mapper/$name to /mnt/$mountname (YES for yes, otherwise No)? " userInput

if ! [ "$userInput" == "YES" ]; then
    echo "Cancelling. No damage done."
    exit 1
fi

printf "/dev/mapper/$name\t/mnt/$mountname\tbtrfs\trw,async,nodev,nosuid,noexec,noatime,auto\t0 0\n" >> /etc/fstab

echo "Reboot and /dev/mapper/$name should be mounted automatically at /mnt/$mountname"