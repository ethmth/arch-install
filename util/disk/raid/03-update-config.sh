#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
	echo "This script must be run with root/sudo privileges."
	exit 1
fi

mdadm --detail --scan >> /etc/mdadm.conf

echo "Added to end of /etc/mdadm.conf:"
tail -n5 /etc/mdadm.conf