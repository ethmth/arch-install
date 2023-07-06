#!/bin/bash

if [[ $EUID -ne 0 ]]; then
        echo "This script should be run with root/sudo privileges."
        exit 1
fi


SCRIPT_PATH=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT_PATH")

if ! [ -d "$SCRIPT_DIR/services/system" ]; then
    echo "$SCRIPT_DIR/services/system not found"
    exit 1
fi

if ! [ -d "$SCRIPT_DIR/services/user" ]; then
    echo "$SCRIPT_DIR/services/user not found"
    exit 1
fi

services=$(ls -1 $SCRIPT_DIR/services/system | grep -v ".txt")
for service in $services; do
    full_path="$SCRIPT_DIR/services/user/$service"
    sudo cp $full_path /etc/systemd/system/$service
    sudo systemctl enable $service
done

services=$(ls -1 $SCRIPT_DIR/services/user | grep -v ".txt")
for service in $services; do
    full_path="$SCRIPT_DIR/services/user/$service"
    sudo cp $full_path /etc/systemd/user/$service
    systemctl --user enable $service
done

systemctl stop packagekit.service
systemctl disable packagekit.service

systemctl disable gdm