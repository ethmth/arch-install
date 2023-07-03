#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script must not be run with root/sudo privileges."
	exit 1
fi

CUR_USER=$(whoami)

cd /home/$CUR_USER/waydroid_script

source .venv/bin/activate

sudo python3 main.py install libhoudini
