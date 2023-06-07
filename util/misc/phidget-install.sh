#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi
CUR_USER=$(whoami)

mkdir /tmp/phidget-temp
wget -O /tmp/phidget-temp/libphidget.tar.gz https://www.phidgets.com/downloads/phidget22/libraries/linux/libphidget22.tar.gz
cd /tmp/phidget-temp
tar -xvf libphidget.tar.gz
DIR_NAME=$(ls /tmp/phidget-temp/ -1 | grep -v "tar.gz")

cd /tmp/phidget-temp/$DIR_NAME
bash /tmp/phidget-temp/$DIR_NAME/configure
make
sudo make install

pip3 install Phidget22
