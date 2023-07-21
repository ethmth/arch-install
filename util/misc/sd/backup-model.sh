#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
        echo "This script should not be run with root/sudo privileges."
        exit 1
fi


IGNORE_LIST="
v1-5-pruned-emaonly.safetensors
"

CUR_USER=$(whoami)

MNT_PTS=$(lsblk --noheadings -o MOUNTPOINTS | grep -v '^$' | grep -v "/boot" | grep -v -x "/")
MNT_ARRAY=()

while IFS= read -r line; do
    MNT_ARRAY+=("$line")
done <<< "$MNT_PTS"
MNT_ARRAY+=("/home/$CUR_USER")
file_array=()


for mnt in "${MNT_ARRAY[@]}"; do
    files=$(find $mnt/programs/stable-diffusion-webui/models/Stable-diffusion 2>/dev/null | grep -v ".txt")
    files+=$(find $mnt/programs/stable-diffusion-webui/models/Lora 2>/dev/null | grep -v ".txt")
    for ignored in $IGNORE_LIST; do
        files=$(echo "$files" | grep -v "$ignored")
    done
    new_files=""
    for file in $files; do
        if ! [ -d "$file" ]; then
            # files=$(echo "$files" | grep -v "$file")
            new_files="$new_files $file"
        fi
    done
    files=$new_files
    for file in $files; do
        echo "$file"
        # file_array+=("$mnt/programs/stable-diffusion-webui/$file")
    done
done

files_string=$(printf "%s\n" "${file_array[@]}")

# POINT=$(echo "$files_string" | fzf --prompt="Select your disk. If you've not created one, press ESC and run ./create-qcow2.sh, then come back")

if ([ "$POINT" == "" ] || [ "$POINT" == "Nothing" ]); then
    echo "No action taken."
    exit 1
fi