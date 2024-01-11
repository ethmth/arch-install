#!/bin/bash

if [[ $EUID -ne 0 ]]; then
	echo "This script should be run with root/sudo privileges."
	exit 1
fi

ufw enable
ufw default deny
ufw allow ssh