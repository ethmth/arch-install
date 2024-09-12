#!/usr/bin/env bash

name="crypttemp"
# path="/etc/mykeys/"

if [[ $EUID -ne 0 ]]; then
	echo "This script must be run with root/sudo privileges."
	exit 1
fi

# if [ ! -d "$path" ]; then
#     mkdir -p "$path"
#     echo "Created directory $path"
# fi

partition=$(echo "$(lsblk --list -f | grep crypto_LUKS | awk '{print $1}')" | fzf --prompt="Please select the crypto_LUKS partition you would like to add to your system.")
partition="/dev/$partition"

echo "Enter the password to unencrypt the disk:"
cryptsetup open "$partition" "$name"
mkfs.ext4 /dev/mapper/$name
sleep 3
cryptsetup close "$name"


echo "To finish setting up the disk, run ./03-add-disk.sh"
