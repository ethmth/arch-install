#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
	echo "This script must be run with root/sudo privileges."
	exit 1
fi

disksuffix=$(fdisk -l | grep "Disk /dev/" | grep -v "loop" | fzf --prompt="Select disk to encrypt" | awk -F'/' '{print $3}' | awk -F':' '{print $1}')
disk="/dev/$disksuffix"

logical_sector_size=$(fdisk -l $disk | grep "Sector size (logical/physical)" | cut -d':' -f2 | cut -d'/' -f1 | xargs | cut -d' ' -f1)
physical_sector_size=$(fdisk -l $disk | grep "Sector size (logical/physical)" | cut -d':' -f2 | cut -d'/' -f2 | xargs | cut -d' ' -f1)
sector_reset=0

if [ "$physical_sector_size" == "4096" ]; then
  if [ "$logical_sector_size" != "$physical_sector_size" ]; then
    fdisk -l "$disk"
    echo "The logical sector size ($logical_sector_size) does not match the physical sector size ($physical_sector_size)."
    read -p "Do you want to set the logical sector size to $physical_sector_size (YES for yes, otherwise No)? " userInput
    if [ "$userInput" == "YES" ]; then
      sector_reset=1
    fi
  fi
fi

if ! (( sector_reset )); then
  echo "Sector size change not needed/supported by this script."
  echo "Exiting with no changes made."
  exit 0
fi

if (( sector_reset )); then
 hdparm --set-sector-size "$physical_sector_size" --please-destroy-my-drive "$disk"
fi

echo "Sector size should have been reset."
echo "REBOOT before making any changes to the disk."