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
    if [ -e "$mnt/programs/stable-diffusion-webui" ]; then
        files+="$mnt/programs/stable-diffusion-webui"
    fi
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
if [ "$mega_mount" == "" ]; then
    echo "Nothing selected"
    exit 1
fi
mega_mount=$(echo "$mega_mount" | awk -F "MEGA" '{print $1}')
if ! [ -e "$mega_mount" ]; then
    echo "Selected location doesn't exist"
    exit 1
fi

BACKUP_PATH="${mega_mount}MEGA/Personal/Software/Models/stable-diffusion-webui"

if ! [ -e "$BACKUP_PATH" ]; then
    echo "$BACKUP_PATH doesn't exist. Exiting."
    exit 1
fi

# FINDING SD MOUNT POINT
sd_mount=""
default_sd_mount=$(echo "$files" | head -n 1)
read -p "Do you want to use $default_sd_mount (Y/n)? " userInput
if ! ([ "$userInput" == "N" ] || [ "$userInput" == "n" ]); then
    sd_mount=$default_sd_mount
else
    sd_mount=$(echo "$files" | fzf --prompt "Select SD installation")
fi
if [ "$sd_mount" == "" ]; then
    echo "Nothing selected"
    exit 1
fi
if ! [ -e "$sd_mount" ]; then
    echo "Selected location doesn't exist"
    exit 1
fi

files=$(cat "$INDEX_FILE" | grep "models")
short_list=$(printf "$files\nALL OF THEM")
desired_files=$(echo "$short_list" | fzf -m --prompt="Select backups to install")
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
    file_name=$(echo "$file" | awk -F "," '{print $1}')
    backup_name=$(echo "$file" | awk -F "," '{print $2}')

    echo "Installing $file_name from $backup_name"
    cp "$BACKUP_PATH/backups/$backup_name" "$sd_mount/$file_name"
done <<< "$files"

echo "Models installed from backup. Check $sd_mount/$file_name for sanity"