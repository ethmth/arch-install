#!/bin/bash

NAME="coverlettergpt"

if ! [[ $EUID -ne 0 ]]; then
        echo "This script should not be run with root/sudo privileges."
        exit 1
fi

CUR_USER=$(whoami)

# LOC=$(lsblk --noheadings -o MOUNTPOINTS | grep -v '^$' | grep -v "/boot" | fzf --prompt="Select your desired $NAME installation location")

# if ([ "$LOC" == "" ] || [ "$LOC" == "Cancel" ]); then
#     echo "Nothing was selected"
#     echo "Run this script again with target drive mounted."
#     exit 1
# fi

# if [ "$LOC" == "/" ]; then
#     LOC="/home/$CUR_USER"
# fi

# if ! [ -d "$LOC" ]; then
#     echo "Your location is not available. Is the disk mounted? Do you have access?"
# 	exit 1
# fi

LOC="/home/$CUR_USER/programs"
mkdir -p $LOC

curl -sSL https://get.wasp-lang.dev/installer.sh | sh

git clone https://github.com/vincanger/coverlettergpt.git $LOC/$NAME

cd $LOC/$NAME

cp env.server.example .env.server

echo "Clone into $LOC/$NAME"
echo "Edit .env.server with your API keys"