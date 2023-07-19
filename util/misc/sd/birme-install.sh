#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
        echo "This script should not be run with root/sudo privileges."
        exit 1
fi

CUR_USER=$(whoami)

LOC=$(lsblk --noheadings -o MOUNTPOINTS | grep -v '^$' | grep -v "/boot" | fzf --prompt="Select your desired kohya installation location")

if ([ "$LOC" == "" ] || [ "$LOC" == "Cancel" ]); then
    echo "Nothing was selected"
    echo "Run this script again with target drive mounted."
    exit 1
fi

if [ "$LOC" == "/" ]; then
    LOC="/home/$CUR_USER"
fi

if ! [ -d "$LOC" ]; then
    echo "Your location is not available. Is the disk mounted? Do you have access?"
	exit 1
fi

DISK=$LOC
LOC="$LOC/programs"
mkdir -p $LOC

git clone https://github.com/livelifebythecode/birme-sd-variant.git $LOC/birme-sd-variant

cd $LOC/birme-sd-variant

sed -i "s/8080/8081/g" docker-compose.yml

docker compose build

echo "birme-sd-variant installed to $LOC. Run 'docker compose up --build' to start"
echo "birme-sd-variant will run on port 8081"
echo "cd $LOC/birme-sd-variant"