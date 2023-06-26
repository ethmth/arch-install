#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
        echo "This script should not be run with root/sudo privileges."
        exit 1
fi

CUR_USER=$(whoami)

MNT_PTS=$(lsblk --noheadings -o MOUNTPOINTS | grep -v '^$' | grep -v "/boot" | grep -v -x "/")
MNT_ARRAY=()

while IFS= read -r line; do
    MNT_ARRAY+=("$line")
done <<< "$MNT_PTS"
MNT_ARRAY+=("/home/$CUR_USER")
file_array=()

for mnt in "${MNT_ARRAY[@]}"; do
    files=$(ls $mnt/vm/disk 2>/dev/null | grep -v "OSX-KVM")
    for file in $files; do
        file_array+=("$mnt/vm/disk/$file")
    done
done

files_string=$(printf "%s\n" "${file_array[@]}")

DISK=$(echo "$files_string" | fzf --prompt="Select your MacOS disk. If you've not created one, press ESC and run ./01-macos-serial.sh, then come back")

if ([ "$DISK" == "" ] || [ "$DISK" == "Nothing" ]); then
    echo "No action taken."
    exit 1
fi

NAME=$(basename "$DISK")
NAME="${NAME%.*}"

sudo modprobe nbd max_part=8
sudo qemu-nbd --connect=/dev/nbd0 $DISK
sudo mount /dev/nbd0p2 /mnt/$NAME




# sudo umount /mnt/$NAME
# qemu-nbd --disconnect /dev/nbd0
# rmmod nbd