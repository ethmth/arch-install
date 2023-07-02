#!/bin/bash

if [[ $EUID -ne 0 ]]; then
	echo "This script must be run with root/sudo privileges."
	exit 1
fi

git clone --depth 1 https://github.com/cilynx/rtl88x2bu.git /opt/rtl88x2bu

cd /opt/rtl88x2bu
make
bash deploy.sh