#!/bin/bash

path="/etc/mykeys/"

if [[ $EUID -ne 0 ]]; then
	echo "This script must be run with root/sudo privileges."
	exit 1
fi

if [ ! -d "$path" ]; then
    mkdir -p "$path"
    echo "Created directory $path"
fi

partition=$(echo "$(lsblk --list -f | grep crypto_LUKS | awk '{print $1}')" | fzf --prompt="Please select the crypto_LUKS partition you would like to add to your system.")
partition="/dev/$partition"


typeofdisk=$(printf "HDD\nSSD\n" | fzf --prompt="Select the type of disk")

SSD=0
HDD=0
if [ "$typeofdisk" == "SSD" ]; then
    SSD=1
else
    HDD=1
fi

read -p "Please the name for the disk: " name

read -p "Are you sure you want to add $partition ($name - $typeofdisk) (YES for yes, otherwise No)? " userInput

if ! [ "$userInput" == "YES" ]; then
    echo "Cancelling. No damage done."
    exit 1
fi
clear

partitionsuffix=$(echo "$partition" | cut -d'/' -f 3)

dd if=/dev/urandom of=$path$name bs=1024 count=1
chmod u=rw,g=,o= $path$name

cryptsetup luksAddKey "$partition" "$path$name"

options="luks"
if (( SSD )); then
    options+=",discard"
fi

uuid_crypt=$(lsblk -f | grep $partitionsuffix | awk '{print $4}')
device_string="UUID=$uuid_crypt"

printf "$name\t$device_string\t$path$name\t$options\n" >> /etc/crypttab

printf "/dev/mapper/$name\t/mnt/$name\text4\tdefaults\t0 1\n" >> /etc/fstab

echo "$name added to /etc/crypttab and /etc/fstab"
echo "Reboot and the disk should be mounted automatically at /mnt/$name"
echo "To give your user, as a part of the storage group, access to the mountpoint, run ./change_ownership.sh as root"
