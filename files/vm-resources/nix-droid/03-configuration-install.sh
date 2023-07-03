#!/bin/bash

if [[ $EUID -ne 0 ]]; then
	echo "This script must be run with root/sudo privileges."
	exit 1
fi

SCRIPT_PATH=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT_PATH")

if ! [ -f "$SCRIPT_DIR/configuration.nix" ]; then
    echo "$SCRIPT_DIR/configuration.nix not found"
    exit 1
fi

cp "$SCRIPT_DIR/configuration.nix" /etc/nixos/configuration.nix

nixos-rebuild switch
systemctl daemon-reload

echo "Reboot. Then, run ./04-install-executables.sh"

