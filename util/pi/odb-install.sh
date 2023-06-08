#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi
CUR_USER=$(whoami)

mkdir /tmp/obd-temp
wget -O /tmp/obd-temp/obd.tar.gz https://github.com/brendan-w/python-OBD/releases/download/v0.7.1/obd-0.7.1.tar.gz
cd /tmp/obd-temp
tar -xvf obd.tar.gz
DIR_NAME=$(ls /tmp/obd-temp/ -1 | grep -v "tar.gz")

cd /tmp/obd-temp/$DIR_NAME
# DON'T RUN ThiS AS SUDO ON ARCH:
# python setup.py install
