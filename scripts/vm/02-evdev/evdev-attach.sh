#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
        echo "This script should be run with root/sudo privileges."
        exit 1
fi

VM=$1
VM_LIST="$VM"

if [[ -z "$VM" ]]; then
        VM_LIST=$(cat /etc/libvirt/hooks-scripts/evdev-vms.list)
fi

echo "VM LIST: $VM_LIST"

DEVICE_LIST=$(cat /etc/libvirt/hooks-scripts/evdev-devices.list)

echo "DEVICE LIST: $DEVICE_LIST"

XML_CONTENT="<devices>\n"
for device in $DEVICE_LIST; do
        if [[ -z "$device" ]]; then
                continue
        fi
        XML_CONTENT+="\t<input type='evdev'>\n"
        XML_CONTENT+="\t\t<source dev='$device'/>\n"
        XML_CONTENT+="\t</input>\n"
done
XML_CONTENT+="</devices>\n"

mkdir -p /etc/libvirt/hooks/devices/

printf "$XML_CONTENT" > /etc/libvirt/hooks/devices/evdev.xml

for vm in $VM_LIST; do
        virsh attach-device $vm /etc/libvirt/hooks/devices/evdev.xml --live
done