#!/bin/bash

PROGRAM_NAME="rustdesk"

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi

CUR_USER=$(whoami)

GROUP_ID=$(id -g)
USER_ID=$(id -u)

mkdir -p /home/$CUR_USER/programs/$PROGRAM_NAME

if ! [ -e "$PROGRAM_NAME/$PROGRAM_NAME" ]; then
	echo "Make sure you run this script in the same directory as ./$PROGRAM_NAME/$PROGRAM_NAME"
	exit 1
fi

cp $PROGRAM_NAME/docker-compose.yml /home/$CUR_USER/programs/$PROGRAM_NAME/docker-compose.yaml

sudo -k cp $PROGRAM_NAME/$PROGRAM_NAME /usr/bin/$PROGRAM_NAME
sudo chmod +x /usr/bin/$PROGRAM_NAME

echo "Installed $PROGRAM_NAME to bin"
echo "Run '$PROGRAM_NAME' to start the container and '$PROGRAM_NAME stop' to stop"