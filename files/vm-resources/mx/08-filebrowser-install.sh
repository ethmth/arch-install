#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi

CUR_USER=$(whoami)

GROUP_ID=$(id -g)
USER_ID=$(id -u)

mkdir -p /home/$CUR_USER/programs/filebrowser
mkdir -p /home/$CUR_USER/Content
touch /home/$CUR_USER/programs/filebrowser/filebrowser.db

if ! [ -e "filebrowser/filebrowser" ]; then
	echo "Make sure you run this script in the same directory as ./filebrowser/filebrowser"
	exit 1
fi

cp filebrowser/docker-compose.yml /home/$CUR_USER/programs/filebrowser/docker-compose.yaml

sed -i "s/CUR_USER_HERE/$CUR_USER/g" /home/$CUR_USER/programs/filebrowser/docker-compose.yaml
sed -i "s/USER_ID_HERE/$USER_ID/g" /home/$CUR_USER/programs/filebrowser/docker-compose.yaml
sed -i "s/GROUP_ID_HERE/$GROUP_ID/g" /home/$CUR_USER/programs/filebrowser/docker-compose.yaml

sudo -k cp filebrowser/filebrowser /usr/bin/filebrowser
sudo chmod +x /usr/bin/filebrowser

echo "Installed filebrowser to bin"
echo "Run 'filebrowser' to start the container and 'filebrowser stop' to stop"