#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
	echo "This script must be run with root/sudo privileges."
	exit 1
fi

partition=$(echo "$(lsblk --list | grep "raid1" | awk '{print $1}')" | fzf --prompt="Please select the RAID device you would like to reset.")
if [ "$partition" == "" ]; then
	echo "Nothing selected."
	exit 1
fi
disk="/dev/$partition"

read -p "Are you sure you want to wipe $disk (YES for yes, otherwise No)? " userInput

if ! [ "$userInput" == "YES" ]; then
    echo "Cancelling. No damage done."
    exit 1
fi

sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk ${disk}
  g # clear the in memory partition table
  w # write the partition table
EOF
echo "Partition created:"
fdisk -l "$disk"