#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script must not be run with root/sudo privileges."
	exit 1
fi
CUR_USER=$(whoami)

SCRIPT_PATH=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT_PATH")

if ! [ -f "$SCRIPT_DIR/configuration.nix" ]; then
    echo "$SCRIPT_DIR/configuration.nix not found"
    exit 1
fi

if [ -d "/home/$CUR_USER/install-scripts" ]; then
    rm -rf "/home/$CUR_USER/install-scripts"
fi

cp -r "$SCRIPT_DIR" "/home/$CUR_USER/install-scripts"

echo "Install scripts placed in ~/install-scripts. Run ./02-network.sh there"
echo "cd ~/install-scripts"