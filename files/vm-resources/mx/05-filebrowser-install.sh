#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi

CUR_USER=$(whoami)

mkdir -p /home/$CUR_USER/programs/filebrowser
mkdir -p /home/$CUR_USER/Content
touch /home/$CUR_USER/programs/filebrowser/filebrowser.db

if ! [ -e "filebrowser" ]; then
	echo "Make sure you run this script in the same directory as ./filebrowser"
	exit 1
fi
sudo -k cp filebrowser /usr/bin/filebrowser
sudo chmod +x /usr/bin/filebrowser

echo "Installed filebrowser to bin"
echo "Run 'filebrowser' to start the container and 'filebrowser stop' to stop"