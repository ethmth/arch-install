#!/bin/bash

if [[ $EUID -ne 0 ]]; then
	echo "This script should be run with root/sudo privileges."
	exit 1
fi

snaps="
codium
chromium
"

snaps=${snaps//$'\n'/ }
snaps=$(echo "$snaps" | tr -s ' ' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

for snap in $snaps; do
	sudo snap install --classic $snap
done
