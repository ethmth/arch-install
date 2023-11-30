#!/bin/bash

NAME="fah"

if ! [[ $EUID -ne 0 ]]; then
        echo "This script should not be run with root/sudo privileges."
        exit 1
fi

CUR_USER=$(whoami)

GROUP_ID=$(id -g)
USER_ID=$(id -u)

VIDEO_ID=$(getent group video | awk -F: '{for(i=1; i<=NF; i++) if($i ~ /^[0-9]+$/) print $i}')
RENDER_ID=$(getent group render | awk -F: '{for(i=1; i<=NF; i++) if($i ~ /^[0-9]+$/) print $i}')

if ! [ -e "../$NAME/docker-compose.yml" ]; then
	echo "Make sure you run this script in the same directory as ../$NAME/docker-compose.yml"
	exit 1
fi


LOC=$(lsblk --noheadings -o MOUNTPOINTS | grep -v '^$' | grep -v "/boot" | fzf --prompt="Select your desired $NAME installation location")

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

mkdir -p $LOC/$NAME
mkdir -p $LOC/$NAME/$NAME
chmod -R 777 $LOC/$NAME/$NAME

cp docker-compose.yml $LOC/$NAME/docker-compose.yml
cp config.xml $LOC/$NAME/$NAME/config.xml

sed -i "s/USER_ID_HERE/$USER_ID/g" $LOC/$NAME/docker-compose.yml
sed -i "s/GROUP_ID_HERE/$GROUP_ID/g" $LOC/$NAME/docker-compose.yml
sed -i "s/RENDER_ID_HERE/$RENDER_ID/g" $LOC/$NAME/docker-compose.yml
sed -i "s/VIDEO_ID_HERE/$VIDEO_ID/g" $LOC/$NAME/docker-compose.yml

cd $LOC/$NAME/

echo "Run 'docker compose up --build -d' to run it and 'docker compose stop' to stop it from that directory"
echo "cd $LOC/$NAME"
