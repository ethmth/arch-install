#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
        echo "This script should be run with root/sudo privileges."
        exit 1
fi

DISK=$(lsblk --noheadings -o MOUNTPOINTS | grep -v '^$' | grep -v "/boot" | grep -v -x "/" | fzf --prompt="Select your desired Whonix installation location")

if ([ "$DISK" == "" ] || [ "$DISK" == "Cancel" ]); then
    echo "Nothing was selected"
    exit 1
fi

chown -R root:storage $DISK
chmod -R g+rwx $DISK
# chown -R root:e $DISK
# chmod -R g-rwx $DISK

echo "As long as your user is part of the storage group, you should have access to $DISK"