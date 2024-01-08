#!/bin/bash

if [[ $EUID -ne 0 ]]; then
        echo "This script should be run with root/sudo privileges."
        exit 1
fi

sudo curl --progress-bar --proto '=https' --tlsv1.2 -Sf https://repo.waydro.id/waydroid.gpg --output /usr/share/keyrings/waydroid.gpg

sudo apt update && sudo apt upgrade -y