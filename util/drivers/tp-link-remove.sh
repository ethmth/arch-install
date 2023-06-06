#!/bin/bash

if [[ $EUID -ne 0 ]]; then
	echo "This script must be run with root/sudo privileges."
	exit 1
fi

driver=$(dkms status -m 8812au | sed 's/\s\+/\n/g' | grep "8812" | sed 's/,*$//g')

dkms remove $driver
