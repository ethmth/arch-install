#!/bin/bash

# Install my dotfiles

# Install openair-vpn

# Choose which GPU to start on

# Choose what to do to other disks, encrypt 8 GB HDD?

# Disk partititioning
path="/etc/mykeys/"

if [[ $EUID -ne 0 ]]; then
	echo "This script must be run with root/sudo privileges."
	exit 1
fi

if [ ! -d "$path" ]; then
    mkdir -p "$path"
    echo "Created directory $path"
fi

disksuffix=$(fdisk -l | grep "Disk /dev/" | grep -v "loop" | fzf --prompt="Select disk for BOOT and ROOT partitions" | awk -F'/' '{print $3}' | awk -F':' '{print $1}')
disk="/dev/$disksuffix"

typeofdisk=$(printf "HDD\nSSD\n" | fzf --prompt="Select the type of disk")

SSD=0
HDD=0
if [ "$typeofdisk" == "SSD" ]; then
    SSD=1
else
    HDD=1
fi

read -p "Please input your desired name for the disk: " name

read -p "Are you sure you want to format $disk ($name - $typeofdisk) (YES for yes, otherwise No)? " userInput

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