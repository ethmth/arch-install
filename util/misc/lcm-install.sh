#!/bin/bash

if [[ $EUID -ne 0 ]]; then
	echo "This script should be run with root/sudo privileges."
	exit 1
fi

git clone https://github.com/lcm-proj/lcm.git /tmp/lcm

mkdir /tmp/lcm/build
cd /tmp/lcm/build
cmake ..
make
make install

