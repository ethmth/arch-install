#!/bin/bash

if [[ $EUID -ne 0 ]]; then
	echo "This script must be run with root/sudo privileges."
	exit 1
fi

git clone https://github.com/aircrack-ng/rtl8812au.git /tmp/rtl8812au

cd /tmp/rtl8812au
make dkms_install