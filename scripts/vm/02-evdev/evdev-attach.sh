#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
        echo "This script should be run with root/sudo privileges."
        exit 1
fi

VM=$1
VM_LIST=$(cat /etc/libvirt/hooks-scripts/evdev-vms.list)

if ! [[ -z "$VM" ]]; then
        echo "VM $VM is set."
        if ! [[ "$VM_LIST" == *"$VM"* ]]; then
                echo "VM $VM is not in the list."
                exit 0
        fi
        VM_LIST="$VM"
fi

echo "VM LIST: $VM_LIST"

DEVICE_LIST=$(cat /etc/libvirt/hooks-scripts/evdev-devices.list)

echo "DEVICE LIST: $DEVICE_LIST"

for device in $DEVICE_LIST; do
        if [[ -z "$device" ]]; then
                continue
        fi
        XML_CONTENT="<input type='evdev'>\n"
        XML_CONTENT+="\t<source dev='$device' "
        KBD_M=`echo "$device" | rev | cut -c -4 | rev`
        if [[ "$KBD_M" == "-kbd" ]]; then
                XML_CONTENT+="grab='all' repeat='on' grabToggle='ctrl-ctrl'"
        fi
        XML_CONTENT+=" />\n"
        XML_CONTENT+="</input>\n"
        # printf "$XML_CONTENT"
        printf "$XML_CONTENT" > /tmp/evdev.xml
        for vm in $VM_LIST; do
                if [[ -z "$vm" ]]; then
                        continue
                fi
                echo "Attaching device $device to VM $vm"
                virsh attach-device $vm /tmp/evdev.xml --live
        done
done
