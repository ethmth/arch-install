#!/bin/bash

if [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi

if ! [ -e "socat-port-forward" ]; then
	echo "Make sure you run this script in the same directory as socat-port-forward"
	exit 1
fi

cp socat-port-forward /etc/init.d/socat-port-forward
chmod +x /etc/init.d/socat-port-forward

update-rc.d socat-port-forward defaults