#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
        echo "This script should be run with root/sudo privileges."
        exit 1
fi

# SELECT DEVICES

read -p "Do you want to auto-select devices? (y/N): " user_input

DEVICE_LIST=""
DEVICE_DIR="/dev/input/by-id"
if [[ $user_input == "y" ]] || [[ $user_input == "Y" ]]; then
        for entry in `ls -l $DEVICE_DIR/ | grep "event*"`
        do
                KBD_M=`echo "$entry" | rev | cut -c -4 | rev`
                if [ "$KBD_M" = "ouse" ]
                        then
                                DEVICE_LIST+="$DEVICE_DIR/$entry\n"
                elif  [ "$KBD_M" = "-kbd" ]
                then
                                DEVICE_LIST+="$DEVICE_DIR/$entry\n"
                fi
        done
else 
        DEVICES=$(ls -1 $DEVICE_DIR | fzf -m --prompt="Please select your devices")
        if [[ -z "$DEVICES" ]]; then
                echo "No devices selected."
                exit 1
        fi
        DEVICE_LIST=""
        for device in $DEVICES; do
                DEVICE_LIST+="$DEVICE_DIR/$device\n"
        done
fi

# SELECT VIRTUAL MACHINES

VMS=$(virsh list --all --name | fzf -m --prompt="Please select your virtual machines")
if [[ -z "$VMS" ]]; then
        echo "No virtual machines selected."
        exit 1
fi

VM_LIST=""
for vm in $VMS; do
        VM_LIST+="$vm\n"
done

printf "===================== DEVICE LIST =====================\n"
printf "$DEVICE_LIST"
printf "===================== DEVICE LIST =====================\n"

printf "===================== VM LIST =====================\n"
printf "$VM_LIST"
printf "===================== VM LIST =====================\n"


sudo mkdir -p /etc/libvirt/hooks-scripts
printf "$DEVICE_LIST" > /etc/libvirt/hooks-scripts/evdev-devices.list
printf "$VM_LIST" > /etc/libvirt/hooks-scripts/evdev-vms.list


cp evdev-attach.sh /usr/local/bin/evdev-attach
chmod 755 /usr/local/bin/evdev-attach