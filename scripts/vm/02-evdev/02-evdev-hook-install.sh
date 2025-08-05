#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
        echo "This script should be run with root/sudo privileges."
        exit 1
fi

if ! [[ -f "evdev-hook.sh" ]]; then
        echo "evdev-hook.sh not found."
        exit 1
fi

mkdir -p /etc/libvirt/hooks
cp evdev-hook.sh /etc/libvirt/hooks/qemu
chmod 755 /etc/libvirt/hooks/qemu


