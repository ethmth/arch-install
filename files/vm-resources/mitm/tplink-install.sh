#!/bin/bash

if [[ $EUID -ne 0 ]]; then
	echo "This script must be run with root/sudo privileges."
	exit 1
fi

git clone --depth 1 https://github.com/morrownr/8821au-20210708.git /opt/8821au

cd /opt/8821au
sh install-driver.sh