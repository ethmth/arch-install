#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
        echo "This script should be run with root/sudo privileges."
        exit 1
fi

# SELECT DEVICES

DEVICE_DIR="/dev/input/by-id"

DEVICES=$(ls -1 $DEVICE_DIR | fzf -m --prompt="Please select your devices")


DEVICE_LIST=""
for device in $DEVICES; do
        DEVICE_LIST+="$DEVICE_DIR/$device\n"
done


sudo mkdir -p /etc/libvirt/hooks-scripts
printf "$DEVICE_LIST" > /etc/libvirt/hooks-scripts/evdev-devices.list


# SELECT VIRTUAL MACHINES

VMS=$(virsh list --all --name | fzf -m --prompt="Please select your virtual machines")

VM_LIST=""
for vm in $VMS; do
        VM_LIST+="$vm\n"
done

printf "$VM_LIST" > /etc/libvirt/hooks-scripts/evdev-vms.list


cp evdev-attach.sh /usr/local/bin/evdev-attach
chmod 755 /usr/local/bin/evdev-attach