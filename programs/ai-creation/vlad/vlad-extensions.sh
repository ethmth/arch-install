#!/bin/bash

BASE_NAME="vlad-diffusion"
NAME=$BASE_NAME

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
    files=$(ls -1 $mnt/programs 2>/dev/null | grep "$NAME")
    for file in $files; do
        file_array+=("$mnt/programs/$file")
    done
done

files_string=$(printf "%s\n" "${file_array[@]}")

DISK=$(echo "$files_string" | fzf --prompt="Select your $NAME Installation. If you've not installed it, press ESC and run ./sd-install.sh, then come back")

if ([ "$DISK" == "" ] || [ "$DISK" == "Nothing" ]); then
    echo "No action taken."
    exit 1
fi

LOC=$DISK

if ! [ -d "$LOC" ]; then
    echo "Your location is not available. Is $NAME Installed? Do you have access?"
	exit 1
fi

# source $LOC/venv/bin/activate
# $LOC/venv/bin/pip install insightface==0.7.3

mkdir -p $LOC/models/roop

LOC="$LOC/extensions"

git clone https://github.com/Bing-su/adetailer.git $LOC/adetailer
git clone https://github.com/Coyote-A/ultimate-upscale-for-automatic1111.git $LOC/ultimate-upscale-for-automatic1111
git clone https://github.com/toshiaki1729/stable-diffusion-webui-dataset-tag-editor.git $LOC/dataset-tag-editor
git clone https://github.com/Gourieff/sd-webui-reactor.git $LOC/sd-webui-reactor
git clone https://github.com/GeorgLegato/stable-diffusion-webui-vectorstudio.git $LOC/stable-diffusion-webui-vectorstudio

echo "Move inswapper_128.onnx from extensions/sd-webui-reactor/models/roop/ to models/roop after starting once"