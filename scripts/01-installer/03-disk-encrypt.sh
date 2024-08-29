#!/bin/bash

# Disk formatting/encryption and mounting
disk=""
disk=$(echo "$(lsblk --list | grep disk | awk '{print $1}')" | fzf --prompt="Please select the disk you just formatted")
if [ "$disk" == "" ]; then
    echo "No disk selected. Nothing done."
    exit 1
fi
partition=$(lsblk --list | grep $disk | grep part | awk '{print $1}' | grep '1$' | rev | cut -c 2- | rev)
partitionsuffix=$partition
partition="/dev/$partition"

mkfs.fat -F32 "${partition}1"
echo "Encryption setup for root filesystem:"
cryptsetup luksFormat "${partition}2"
echo "Enter the password to unencrypt the disk:"
cryptsetup open "${partition}2" "cryptroot"
mkfs.ext4 /dev/mapper/cryptroot
mount /dev/mapper/cryptroot /mnt
mount --mkdir "${partition}1" /mnt/boot
lsblk

echo "Verify that the mountpoints listed above are correct (/mnt and /mnt/boot mounted)"
echo "If so, run ./04-pacstrap.sh"
