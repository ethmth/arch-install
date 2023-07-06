#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script must not be run with root/sudo privileges."
	exit 1
fi

waydroid prop set persist.waydroid.width 768
waydroid prop set persist.waydroid.height 1480
waydroid prop set persist.waydroid.suspend false
waydroid prop set persist.waydroid.uevent true
waydroid prop set persist.waydroid.multi_windows false