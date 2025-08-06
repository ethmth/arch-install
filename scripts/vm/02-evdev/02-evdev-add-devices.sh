#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
        echo "This script should be run with root/sudo privileges."
        exit 1
fi


VM_LIST=$(cat /etc/libvirt/hooks-scripts/evdev-vms.list | fzf -m --prompt="Please select the virtual machines to edit")
if [[ -z "$VM_LIST" ]]; then
        echo "Nothing selected. Exiting"
        exit 0
fi

echo "VM LIST: $VM_LIST"

DEVICE_LIST=$(cat /etc/libvirt/hooks-scripts/evdev-devices.list)

echo "DEVICE LIST: $DEVICE_LIST"

XML_CONTENT=""
for device in $DEVICE_LIST; do
        if [[ -z "$device" ]]; then
                continue
        fi
        XML_CONTENT+="<input type='evdev'>\n"
        XML_CONTENT+="\t<source dev='$device' "
        KBD_M=`echo "$device" | rev | cut -c -4 | rev`
        if [[ "$KBD_M" == "-kbd" ]]; then
                XML_CONTENT+="grab='all' repeat='on' grabToggle='ctrl-ctrl'"
        fi
        XML_CONTENT+=" />\n"
        XML_CONTENT+="</input>\n"
done
XML_CONTENT+="\n"

echo "XML_CONTENT: $XML_CONTENT"

for vm in $VM_LIST; do
        if [[ -z "$vm" ]]; then
                continue
        fi
        echo "Adding devices to VM $vm"
        if [ -f "/etc/libvirt/qemu/$vm.xml" ]; then
                # insert XML_CONTENT above </devices>
                sed -i "s|</devices>|${XML_CONTENT}</devices>|" "/etc/libvirt/qemu/$vm.xml"
                virsh define "/etc/libvirt/qemu/$vm.xml"
        else
                echo "VM $vm not found."
        fi
done



