#!/bin/bash

if [[ $EUID -ne 0 ]]; then
	echo "This script must be run with root/sudo privileges."
	exit 1
fi

driver=$(dkms status -m rtl88x2bu | sed 's/\s\+/\n/g' | grep "88x2" | sed 's/,*$//g')

sudo dkms remove $driver --all
find /lib/modules -name cfg80211.ko -ls
sudo rm -f /lib/modules/*/updates/net/wireless/cfg80211.ko