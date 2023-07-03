#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script must not be run with root/sudo privileges."
	exit 1
fi

waydroid prop set persist.waydroid.width 768
waydroid prop set persist.waydroid.height 1280


# echo "MUST ENABLE OPENGL AND VIRTIO ACCELERATION FOR THE VM"
# socat tcp-listen:5555,fork,reuseaddr tcp:192.168.240.112:5555


# TODO - Start weston automatically, start waydroid session after weston's started, start socat command, get it working headlessly, setup libhoudini