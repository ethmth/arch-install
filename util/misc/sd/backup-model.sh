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

files=""
for mnt in "${MNT_ARRAY[@]}"; do
    files+=$(find $mnt/programs/stable-diffusion-webui/models/Stable-diffusion -type f 2>/dev/null | grep -v ".txt")
    files=$(printf "$files\n$(find $mnt/programs/stable-diffusion-webui/models/Lora -type f 2>/dev/null | grep -v ".txt")")
done


for ignored in $IGNORE_LIST; do
    files=$(echo "$files" | grep -v "$ignored")
done

# echo "$files"

desired_files=$(echo "$files" | awk -F "stable-diffusion-webui/models/" '{print $2}' | fzf -m --prompt="Please select files to backup")

echo "$desired_files"
echo "MOVING ON"

new_files=""
# for desired_file in $desired_files; do
#     echo "DESIRED FILE IS $desired_file"
#     new_file=$(echo "$files" | grep "$desired_file")
#     new_files=$(printf "$new_files\n$new_file")
# done


while IFS= read -r desired_file; do
#   echo "Processing: $line"
  # Add your processing logic here for each line
    new_file=$(echo "$files" | grep "$desired_file")
    new_files=$(printf "$new_files\n$new_file")
done <<< "$desired_files"


echo "$new_files" 


# filtered_files=()

# # Loop through each element in the file_list (null-delimited)
# while IFS= read -r -d '' item; do
#     # Check if the current item is a regular file
#     if [ -f "$item" ]; then
#         # If it's a file, add it to the filtered_files array
#         filtered_files+=("$item")
#     fi
# done <<< "$file_list"

# # Print the filtered files (null-delimited)
# printf '%s\0' "${filtered_files[@]}"