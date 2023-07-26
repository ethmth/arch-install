#!/bin/bash

CONTAINER_NAME="kaggle-docker"

VOLUMES="
"

FILES="
docker-compose.yml
"

if ! [[ $EUID -ne 0 ]]; then
        echo "This script should not be run with root/sudo privileges."
        exit 1
fi

CUR_USER=$(whoami)

mkdir -p /home/$CUR_USER/programs/$CONTAINER_NAME

for file in $FILES; do
    if ! [ -e "../$CONTAINER_NAME/$file" ]; then
            echo "$file doesn't exist. Make sure you run this script in the same directory as ../$CONTAINER_NAME/$file"
            exit 1
    fi
done

LOC=$(lsblk --noheadings -o MOUNTPOINTS | grep -v '^$' | grep -v "/boot" | fzf --prompt="Select your desired $CONTAINER_NAME installation location")
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

mkdir -p $LOC/$CONTAINER_NAME

for file in $FILES; do
    cp $file $LOC/$CONTAINER_NAME/$file
done

for vol in $VOLUMES; do
    mkdir $LOC/$CONTAINER_NAME/$vol
    chmod -R 777 $LOC/$CONTAINER_NAME/$vol
done

echo "Installed $CONTAINER_NAME to $LOC"
echo "Run 'docker compose up --build' to start"
echo "cd $LOC/$CONTAINER_NAME"