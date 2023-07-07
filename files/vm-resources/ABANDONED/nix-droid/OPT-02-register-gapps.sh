#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script must not be run with root/sudo privileges."
	exit 1
fi

CUR_USER=$(whoami)

cd /home/$CUR_USER/waydroid_script

source .venv/bin/activate

echo "Copy the numeric ID and enter the id and register it here:"
echo "https://google.com/android/uncertified/?pli=1"
echo "You may need to wait up to 10-20 minutes for the device to get registered"
echo "Then, clear Google Play Service's cache and try logging in."

sudo python3 main.py google