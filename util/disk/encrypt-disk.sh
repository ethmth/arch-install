#!/bin/bash

name="crypttemp"

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

sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk ${disk}
  g # clear the in memory partition table
  n # new partition
  p # primary partition
  1 # partition number 1
    # default, start immediately after preceding partition
    # default, extend partition to end of disk
  w # write the partition table
EOF
echo "Partition created:"
fdisk -l | grep "$disk"

read -p "Do these partitions look correct (N for No, otherwise Yes)? " userInput

if ([ "$userInput" == "N" ] || [ "$userInput" == "n" ]); then
    echo "Manual intervention needed. Exiting script now."
    exit 1
fi
clear

partition=$(fdisk -l | grep $disk | awk '{print $1}' | grep '1$')
partitionsuffix=$(echo "$partition" | cut -d'/' -f 3)


echo "Encryption setup for filesystem:"
cryptsetup luksFormat "$partition"
echo "Enter the password to unencrypt the disk:"
cryptsetup open "$partition" "$name"
mkfs.ext4 /dev/mapper/$name
sleep 3
cryptsetup close "$name"

echo "To finish setting up the disk, run ./add-disk.sh"
