#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi
CUR_USER=$(whoami)

mkdir /tmp/lcm-temp
wget -O /tmp/lcm-temp/lcm.zip https://github.com/lcm-proj/lcm/archive/refs/tags/v1.5.0.zip
cd /tmp/lcm-temp
unzip lcm.zip
DIR_NAME=$(ls /tmp/lcm-temp/ -1 | grep -v "zip")

mkdir /tmp/lcm-temp/$DIR_NAME/build
cd /tmp/lcm-temp/$DIR_NAME/build
cmake ..
make
sudo -k make install

# Might be necessary to install python library (check first):
# sudo python /tmp/lcm-temp/$DIR_NAME/lcm-python/setup.py install
