#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
        echo "This script should not be run with root/sudo privileges."
        exit 1
fi

waydroid prop set persist.waydroid.width 480
waydroid prop set persist.waydroid.height 936
waydroid prop set persist.waydroid.suspend false
waydroid prop set persist.waydroid.uevent true
waydroid prop set persist.waydroid.multi_windows false

echo "Run 'waydroid-script' to install libndk. Restart. Then, run ./10-upgrade-packages.sh"