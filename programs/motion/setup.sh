#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
        echo "This script should not be run with root/sudo privileges."
        exit 1
fi

if ! [ -e "motion.conf" ]; then
	echo "Make sure you run this script in the same directory as motion.conf"
	exit 1
fi

CUR_USER=$(whoami)


mkdir -p /home/$CUR_USER/Pictures/Motion/
sudo cp motion.conf /etc/motion/motion.conf