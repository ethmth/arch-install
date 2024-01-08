#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script must not be run with root/sudo privileges."
	exit 1
fi

if [ -f "./waydroid-script" ]; then
	echo "Make sure you're in the same directory as ./waydroid-script"
	exit 1
fi

sudo cp ./waydroid-script /usr/bin/waydroid-script
sudo chmod 775 /usr/bin/waydroid-script

CUR_USER=$(whoami)

git clone --depth 1 https://github.com/casualsnek/waydroid_script /home/$CUR_USER/waydroid_script

cd /home/$CUR_USER/waydroid_script

sudo python3 -m venv .venv

source .venv/bin/activate

sudo .venv/bin/python -m pip install -r requirements.txt

echo "Waydroid script setup. Run 'waydroid-script'"