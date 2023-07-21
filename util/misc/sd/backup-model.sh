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
# file_array=()

files=""
for mnt in "${MNT_ARRAY[@]}"; do
    files+=$(find $mnt/programs/stable-diffusion-webui/models/Stable-diffusion 2>/dev/null | grep -v ".txt")
    # files=$(printf "%s\n" "${files[@]}")
    # echo "$files"

    # files+=$(printf "\n")
    files=$(printf "$files\n$(find $mnt/programs/stable-diffusion-webui/models/Lora 2>/dev/null | grep -v ".txt")")
    # for ignored in $IGNORE_LIST; do
    #     files=$(echo "$files" | grep -v "$ignored")
    # done
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

echo "$files"

for ignored in $IGNORE_LIST; do
    echo "$ignored"
    files=$(echo "$files" | grep -v "$ignored")
    # files=$(echo "$files")
done

    # files=$(printf "$files")

# new_files=""
# for file in $files; do
#     if ! [ -d "$file" ]; then
#         # new_files=$(echo "$new_files" | grep -v "$file")
#         new_files="$file SEP\n"
#     fi
# done
# files=$new_files

echo "Starting filter"
filtered_files=()

# Loop through each element in the file_list
for item in "$files"; do
    # echo "$item"
    # Check if the current item is a regular file using find and -type f
    if [ -f "$item" ]; then
        # If it's a file, add it to the filtered_files array
        filtered_files+=("$item")
    fi
done

echo "AFTER"
# Print the filtered files
echo "${filtered_files[@]}"

# echo "AFTER"
# echo "$files"
# for something in $files; do
#     echo "HIU TTRHEIJTES"
#     echo "$something"
# done
# echo "$file_array"
# files_string=$(printf "%s\n" "${file_array[@]}")

# echo "$files_string"

# POINT=$(echo "$files_string" | fzf --prompt="Select your disk. If you've not created one, press ESC and run ./create-qcow2.sh, then come back")

if ([ "$POINT" == "" ] || [ "$POINT" == "Nothing" ]); then
    echo "No action taken."
    exit 1
fi