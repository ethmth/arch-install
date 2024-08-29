#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
        echo "This script should not be run with root/sudo privileges."
        exit 1
fi

CUR_USER=$(whoami)

LOC=$(lsblk --noheadings -o MOUNTPOINTS | grep -v '^$' | grep -v "/boot" | fzf --prompt="Select your desired qcow2 installation location")

if ([ "$LOC" == "" ] || [ "$LOC" == "Cancel" ]); then
    echo "Nothing was selected"
    echo "Run this script again with target drive mounted."
    exit 1
fi

if [ "$LOC" == "/" ]; then
    LOC="/home/$CUR_USER"
fi

if ! [ -d "$LOC" ]; then
    echo "Your location is not available. Is the disk mounted? Do you have access?"
	exit 1
fi

LOC="$LOC/vm"
DISK_LOC="$LOC/disk"
mkdir -p $DISK_LOC

read -p "Please input your desired disk name: " DISK_NAME
read -p "Enter your desired disk size in GB: " DISK_SIZE
if ! [[ "$DISK_SIZE" =~ ^[0-9]+$ ]]; then
  echo "Invalid Disk Size. Exiting."
  exit 1
fi

read -p "Do you want to create $DISK_LOC/$DISK_NAME of size $DISK_SIZE GB (YES for Yes)? " userInput

if ! [ "$userInput" == "YES" ]; then
    echo "Exiting. No damage done."
    exit 1
fi

qemu-img create -f qcow2 "$DISK_LOC/$DISK_NAME.qcow2" "${DISK_SIZE}G"

echo "LAST_DISK=$DISK_LOC/$DISK_NAME.qcow2" > /home/$CUR_USER/arch-install/config/last_disk.txt

echo "Disk $DISK_LOC/$DISK_NAME.qcow2 created."
echo "Now run one of the vm creation scripts to define a Virtual machine"
