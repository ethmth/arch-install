#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
	echo "This script must be run with root/sudo privileges."
	exit 1
fi

disksuffix=$(fdisk -l | grep "Disk /dev/" | grep -v "loop" | fzf --prompt="Select disk to partition" | awk -F'/' '{print $3}' | awk -F':' '{print $1}')

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

sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk ${disk}
  g # clear the in memory partition table
  n # new partition
    # default - partition number 1
    # default - start at beginning of disk 
    # default - extend partition to end of disk
  w # write the partition table
EOF
echo "Partition created:"
fdisk -l "$disk"

echo "Paritition should have been created (Check above)."