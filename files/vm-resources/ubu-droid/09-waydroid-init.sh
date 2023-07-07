#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
        echo "This script should not be run with root/sudo privileges."
        exit 1
fi

sudo systemctl enable waydroid-container

sudo waydroid init
