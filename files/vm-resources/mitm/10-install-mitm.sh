#!/bin/bash

if [[ $EUID -ne 0 ]]; then
	echo "This script should be run with root/sudo privileges."
	exit 1
fi

if ! [ -f "./mitm.sh" ]; then
	echo "Make sure you're in the same directory as ./mitm.sh"
	exit 1
fi

cp ./mitm.sh /usr/bin/mitm
chmod +rx /usr/bin/mitm
chmod o+rx /usr/bin/mitm