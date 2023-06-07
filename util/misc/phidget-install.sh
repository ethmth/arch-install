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

# Automatic:
pip3 install Phidget22

# Manual:
#wget -O /tmp/phidget-temp/Phidget22Python.zip https://www.phidgets.com/downloads/phidget22/libraries/any/Phidget22Python.zip
#cd /tmp/phidget-temp
#unzip Phidget22Python.zip
#DIR_NAME=$(ls /tmp/phidget-temp/ -1 | grep "Python" | grep -v "zip")
#cd /tmp/phidget-temp/$DIR_NAME
#sudo -k python3 /tmp/phidget-temp/$DIR_NAME/setup.py install
