#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script must not be run with root/sudo privileges."
	exit 1
fi

SCRIPT_PATH=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT_PATH")

if ! [ -f "$SCRIPT_DIR/waydroid-start" ]; then
    echo "$SCRIPT_DIR/waydroid-start not found"
    exit 1
fi

mkdir -p /home/android/bin
cp "$SCRIPT_DIR/waydroid-start" /home/android/bin/waydroid-start
chmod +x /home/android/bin/waydroid-start