#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi
CUR_USER=$(whoami)

#mkdir /tmp/tk-temp
#wget -O /tmp/tk-temp/tk-src.zip http://prdownloads.sourceforge.net/tcl/tk8613-src.zip
#cd /tmp/tk-temp
#unzip tk-src.zip
#DIR_NAME=$(ls /tmp/tk-temp/ -1 | grep -v "zip")

#cd /tmp/tk-temp/$DIR_NAME/unix
#bash /tmp/tk-temp/$DIR_NAME/unix/configure
#make
#sudo make install

