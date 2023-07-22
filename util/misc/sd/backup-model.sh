#!/bin/bash

IGNORE_LIST="
v1-5-pruned-emaonly.safetensors
"

if ! [[ $EUID -ne 0 ]]; then
        echo "This script should not be run with root/sudo privileges."
        exit 1
fi
CUR_USER=$(whoami)

BACKUP_PATH="MEGA/Personal/Software/Models/stable-diffusion-webui"
INDEX_FILE="/home/$CUR_USER/.local/share/Cryptomator/mnt/SecureModels/stable-diffusion-webui/index.txt"

if ! [ -e "$INDEX_FILE" ]; then
    echo "Cryptomator/mnt/SecureModels/stable-diffusion-webui/index.txt is not available"
    exit 1
fi

# ITERATING THROUGH MOUNT POINTS
MNT_PTS=$(lsblk --noheadings -o MOUNTPOINTS | grep -v '^$' | grep -v "/boot" | grep -v -x "/")
MNT_ARRAY=()
while IFS= read -r line; do
    MNT_ARRAY+=("$line")
done <<< "$MNT_PTS"
MNT_ARRAY+=("/home/$CUR_USER")

files=""
mega_mounts=""
for mnt in "${MNT_ARRAY[@]}"; do
    files+=$(find $mnt/programs/stable-diffusion-webui/models/Stable-diffusion -type f 2>/dev/null | grep -v ".txt")
    files=$(printf "$files\n$(find $mnt/programs/stable-diffusion-webui/models/Lora -type f 2>/dev/null | grep -v ".txt")")

    mega_mounts=$(printf "$mnt/$(ls -1 $mnt | grep -v "sync" | grep "MEGA")\n$mega_mounts" | grep "MEGA")
done

# FINDING MEGA MOUNT POINT
mega_mount=""
mega_non_home_mount=$(echo "$mega_mounts" | grep -v "home" | head -n 1)
THERE_IS_NON_HOME=$(echo "$mega_non_home_mount" | wc -l)
default_mount=$mega_non_home_mount
if ! (( THERE_IS_NON_HOME )); then
    default_mount=$(echo "$mega_mounts" | grep "home" | head -n 1)
fi
read -p "Do you want to use $default_mount (Y/n)? " userInput
if ! ([ "$userInput" == "N" ] || [ "$userInput" == "n" ]); then
    mega_mount=$default_mount
else
    mega_mount=$(echo "$mega_mounts" | fzf --prompt "Select MEGA mount")
fi
mega_mount=$(echo "$mega_mount" | awk -F "MEGA" '{print $1}')

BACKUP_PATH="${mega_mount}MEGA/Personal/Software/Models/stable-diffusion-webui"

if ! [ -e "$BACKUP_PATH" ]; then
    echo "$BACKUP_PATH doesn't exist. Exiting."
    exit 1
fi

mkdir -p $BACKUP_PATH/backups

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

    EXISTS=$(cat "$INDEX_FILE" | grep "$short_file" | wc -l)

    random_name=$(cat /dev/urandom | tr -cd 'a-f0-9' | head -c 32)

    if (( EXISTS )); then
        echo "$short_file already backed up. Moving on."
    else
        echo "Backing up $short_file as $random_name"
        echo "$short_file,$random_name" >> "$INDEX_FILE"
        cp "$file" "$BACKUP_PATH/backups/$random_name"
    fi
done <<< "$files"

echo "Models backed up. Check $INDEX_FILE and $BACKUP_PATH/backups for sanity"