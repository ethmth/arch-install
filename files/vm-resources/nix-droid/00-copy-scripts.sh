#!/bin/bash

if [[ $EUID -ne 0 ]]; then
	echo "This script must not be run with root/sudo privileges."
	exit 1
fi

SCRIPT_PATH=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT_PATH")

if ! [ -f "$SCRIPT_DIR/configuration.nix" ]; then
    echo "$SCRIPT_DIR/configuration.nix not found"
    exit 1
fi

cp -r "$SCRIPT_DIR" ~/nix-droid