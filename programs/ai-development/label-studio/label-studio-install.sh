#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
        echo "This script should not be run with root/sudo privileges."
        exit 1
fi

CUR_USER=$(whoami)

LOC=$(lsblk --noheadings -o MOUNTPOINTS | grep -v '^$' | grep -v "/boot" | fzf --prompt="Select your desired Label Studio installation location")

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

LOC="$LOC/programs"
mkdir -p $LOC

mkdir -p $LOC/label-studio/mydata

chmod -R 777 $LOC/label-studio/mydata

cp /home/$CUR_USER/arch-install/util/misc/label-studio/docker-compose.yml $LOC/label-studio/docker-compose.yml

cd $LOC/label-studio/

echo "Default login admin@admin.com:password"
echo "Label studio installed at $LOC/label-studio/docker-compose.yml"
echo "Run 'docker compose up --build -d' to run it and 'docker compose stop' to stop it from that directory"
echo "cd $LOC/label-studio"