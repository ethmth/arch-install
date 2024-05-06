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
    files=$(ls -1 $mnt/programs 2>/dev/null | grep "text-generation-webui")
    for file in $files; do
        file_array+=("$mnt/programs/$file")
    done
done

files_string=$(printf "%s\n" "${file_array[@]}")

DISK=$(echo "$files_string" | fzf --prompt="Select your Text UI Installation")

if ([ "$DISK" == "" ] || [ "$DISK" == "Nothing" ]); then
    echo "No action taken."
    exit 1
fi

LOC=$DISK

if ! [ -d "$LOC" ]; then
    echo "Your location is not available. Is the TextUI installed? Do you have access?"
	exit 1
fi

LOC="$LOC/models"
cd $LOC

git lfs install
git clone https://huggingface.co/TheBloke/Llama-2-7b-Chat-GPTQ
