#!/bin/bash

# Disk partititioning
disk=""
disk=$(fdisk -l | grep "Disk /dev/" | grep -v "loop" | fzf --prompt="Select disk for BOOT and ROOT partitions" | awk -F'/' '{print $3}' | awk -F':' '{print $1}')
if [ "$disk" == "" ]; then
    echo "No disk selected. Nothing done."
    exit 1
fi
disk="/dev/$disk"

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
    # default - start at beginning of disk 
  +1G # 1 GB boot parttion
  n # new partition
  p # primary partition
  2 # partion number 2
    # default, start immediately after preceding partition
    # default, extend partition to end of disk
  t # change partition type
  1 # partition number (1)
  1 # partion type (1 - EFI system)
  w # write the partition table
EOF
echo "Partitions created:"
fdisk -l | grep "$disk"

echo "Verify that the partitions above for disk $disk look correct."
echo "If so, run ./03-disk-encrypt.sh"
