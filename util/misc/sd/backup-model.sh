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

# files=()
for mnt in "${MNT_ARRAY[@]}"; do
    file_array+=$(find $mnt/programs/stable-diffusion-webui/models/Stable-diffusion 2>/dev/null | grep -v ".txt")
    # files=$(printf "%s\n" "${files[@]}")
    # echo "$files"

    # files+=$(printf "\n")
    file_array+=$(find $mnt/programs/stable-diffusion-webui/models/Lora 2>/dev/null | grep -v ".txt")
    for ignored in $IGNORE_LIST; do
        file_array=$(echo "$file_array" | grep -v "$ignored")
    done
    # echo "$files"
    # new_files="$files"
    # for file in $files; do
    #     if [ -d "$file" ]; then
    #         new_files=$(echo "$new_files" | grep -v "$file")
    #     fi
    # done
    # echo "$files"
    # echo "$new_files"
    # files=$new_files
    # for file in $files; do
    #     echo "$file"
    #     # extracted_part=$(echo "$file" | awk -F "stable-diffusion-webui/models" '{print substr($0, length($1)+1)}')
    #     # echo "$extracted_part"
    # done
    # echo "$mnt"
    # echo "$files"
done

for something in $file_array; do
    echo "HIU TTRHEIJTES"
    echo "$something"
done
# echo "$file_array"
files_string=$(printf "%s\n" "${file_array[@]}")

# echo "$files_string"

# POINT=$(echo "$files_string" | fzf --prompt="Select your disk. If you've not created one, press ESC and run ./create-qcow2.sh, then come back")

if ([ "$POINT" == "" ] || [ "$POINT" == "Nothing" ]); then
    echo "No action taken."
    exit 1
fi