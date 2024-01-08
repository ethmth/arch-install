#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
        echo "This script should not be run with root/sudo privileges."
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
    full_path="$SCRIPT_DIR/services/system/$service"
    sudo cp $full_path /etc/systemd/system/$service
    sudo chmod 755 /etc/systemd/system/$service
    WANTED=$(cat /etc/systemd/system/$service | grep "WantedBy" | wc -l)
    if ((WANTED)); then
        sudo systemctl enable $service
    fi
done

services=$(ls -1 $SCRIPT_DIR/services/user | grep -v ".txt")
for service in $services; do
    full_path="$SCRIPT_DIR/services/user/$service"
    sudo cp $full_path /etc/systemd/user/$service
    sudo chmod 755 /etc/systemd/user/$service
    WANTED=$(cat /etc/systemd/user/$service | grep "WantedBy" | wc -l)
    if ((WANTED)); then
        systemctl --user enable $service
    fi
done

sudo systemctl stop packagekit.service
sudo systemctl disable packagekit.service

sudo systemctl disable gdm

systemctl --user daemon-reload
sudo systemctl daemon-reload