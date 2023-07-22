#!/bin/bash

IGNORE_LIST="
v1-5-pruned-emaonly.safetensors
"

if ! [[ $EUID -ne 0 ]]; then
        echo "This script should not be run with root/sudo privileges."
        exit 1
fi
CUR_USER=$(whoami)

BACKUP_PATH="/home/$CUR_USER/.local/share/Cryptomator/mnt/SecureModels/stable-diffusion-webui"

if ! [ -e "$BACKUP_PATH/index.txt" ]; then
    echo "Cryptomator/mnt/SecureModels/stable-diffusion-webui/index.txt is not available"
    exit 1
fi

mkdir -p $BACKUP_PATH/backups


MNT_PTS=$(lsblk --noheadings -o MOUNTPOINTS | grep -v '^$' | grep -v "/boot" | grep -v -x "/")
MNT_ARRAY=()

while IFS= read -r line; do
    MNT_ARRAY+=("$line")
done <<< "$MNT_PTS"
MNT_ARRAY+=("/home/$CUR_USER")

files=""
for mnt in "${MNT_ARRAY[@]}"; do
    files+=$(find $mnt/programs/stable-diffusion-webui/models/Stable-diffusion -type f 2>/dev/null | grep -v ".txt")
    files=$(printf "$files\n$(find $mnt/programs/stable-diffusion-webui/models/Lora -type f 2>/dev/null | grep -v ".txt")")
done


for ignored in $IGNORE_LIST; do
    files=$(echo "$files" | grep -v "$ignored")
done

short_list=$(echo "$files" | awk -F "stable-diffusion-webui/models/" '{print $2}')
short_list=$(printf "$short_list\nALL OF THEM")
desired_files=$(echo "$short_list" | fzf -m --prompt="Please select files to backup")

ALL_OF_THEM=$(echo "$desired_files" | grep "ALL OF THEM" | wc -l)

if ! (( ALL_OF_THEM )); then
    new_files=""
    while IFS= read -r desired_file; do
        new_file=$(echo "$files" | grep "$desired_file")
        new_files=$(printf "$new_file\n$new_files")
    done <<< "$desired_files"
    files=$new_files
else
    desired_files=$short_list
fi

while IFS= read -r file; do
    short_file=$(echo "$file" | awk -F "stable-diffusion-webui/" '{print $2}')

    EXISTS=$(cat "$BACKUP_PATH/index.txt" | grep "$short_file" | wc -l)

    random_name=$(cat /dev/urandom | tr -cd 'a-f0-9' | head -c 32)

    if (( EXISTS )); then
        echo "$short_file already exists"
    else
        echo "$short_file,$random_name" >> "$BACKUP_PATH/index.txt"
        cp $file $BACKUP_PATH/backups/$random_name
    fi
done <<< "$files"

echo "Models backed up. Check $BACKUP_PATH/index.txt and $BACKUP_PATH/backups for sanity"