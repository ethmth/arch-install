#!/usr/bin/env bash

RAID_PARTITION_UUID="a19d880f-05fc-4d3b-a006-743f0f84911e"

if [[ $EUID -ne 0 ]]; then
	echo "This script must be run with root/sudo privileges."
	exit 1
fi

read -p "Are you sure you want to create a RAID1 Array (mirroring EXACTLY TWO partitions) (YES for yes, otherwise No)? " userInput

if ! [ "$userInput" == "YES" ]; then
    echo "Cancelling. No damage done."
    exit 1
fi

raid_partition_count=$(lsblk --list -f -o +PARTTYPE | grep "$RAID_PARTITION_UUID" | awk '{print $1}' | wc -l)
if [ "$raid_partition_count" -lt "2" ]; then
  echo "Less than 2 RAID partitions found. Cannot proceed."
  exit 1
fi

partition1=$(echo "$(lsblk --list -f -o +PARTTYPE | grep "$RAID_PARTITION_UUID" | awk '{print $1}')" | fzf --prompt="Please select partition 1.")
if [ "$partition1" == "" ]; then
  echo "Partition 1 not selected."
  exit 1
fi
partition1="/dev/$partition1"

partition2=$(echo "$(lsblk --list -f -o +PARTTYPE | grep "$RAID_PARTITION_UUID" | awk '{print $1}')" | fzf --prompt="Please select partition 2.")
if [ "$partition2" == "" ]; then
  echo "Partition 2 not selected."
  exit 1
fi
partition2="/dev/$partition2"

if [ "$partition1" == "$partition2" ]; then
  echo "Partitions 1 and 2 cannot be the same."
  exit 1
fi

read -p "Please the name for the disk: " name
if [ "$name" == "" ]; then
  echo "Name cannot be empty"
  exit 1
fi

read -p "Do you want to create a RAID1 array named $name with $partition1 and $partition2 (YES for yes, otherwise No)? " userInput

if ! [ "$userInput" == "YES" ]; then
    echo "Cancelling. No damage done."
    exit 1
fi

echo "mdadm --create --verbose --level=1 --metadata=1.2 --raid-devices=2 \"/dev/md/$name\" \"$partition1\" \"$partition2\""

mdadm --create --verbose --level=1 --metadata=1.2 --raid-devices=2 "/dev/md/$name" "$partition1" "$partition2"