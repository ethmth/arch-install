#!/bin/bash

if [[ $EUID -ne 0 ]]; then
	echo "This script should be run with root/sudo privileges."
	exit 1
fi

snaps="
codium
"

snaps=${snaps//$'\n'/ }
snaps=$(echo "$snaps" | tr -s ' ' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
sudo snap install --classic $snaps

