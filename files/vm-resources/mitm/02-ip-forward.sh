#!/bin/bash

if [[ $EUID -ne 0 ]]; then
	echo "This script must be run with root/sudo privileges."
	exit 1
fi

echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf

sysctl -p
