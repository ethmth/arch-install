#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
        echo "This script should not be run with root/sudo privileges."
        exit 1
fi

CUR_USER=$(whoami)
# source /home/$CUR_USER/arch-install/config/last_disk.txt

if ! [ -e "/home/$CUR_USER/vm/tools/evdev_helper/evdev.txt" ]; then
    echo "/home/$CUR_USER/vm/tools/evdev_helper/evdev.txt doesn't exist"
    echo "Please be sure you've run /evdev-setup.sh"
    exit 1
fi

# echo "Please be sure you've run /evdev-setup.sh"
# read -p "Press ENTER to continue" userInput

VM=$(ls -1 /etc/libvirt/qemu | grep ".xml" | fzf --prompt="Select the VM you'd like to add evdev to")

if ([ "$VM" == "" ] || [ "$VM" == "Nothing" ]); then
    echo "Nothing selected."
    exit 1
fi

if ! [ -e "/etc/libvirt/qemu/$VM" ]; then
    echo "Invalid file selected"
    exit 1
fi

sudo -k cp /etc/libvirt/qemu/$VM /home/$CUR_USER/vm/templates/$VM

sed -i '/<domain/,$!d' /home/$CUR_USER/vm/templates/$VM

NEW_DOMAIN=$(cat /home/$CUR_USER/vm/tools/evdev_helper/evdev.txt | grep "<domain")

sed -i "s|.*<domain.*|$NEW_DOMAIN|" /home/$CUR_USER/vm/templates/$VM

NEW_QEMU=$(cat /home/$CUR_USER/vm/tools/evdev_helper/evdev.txt | grep . | grep -v "<domain")
# NEW_QEMU=$(printf '%s\n' "$NEW_QEMU" | sed -e 's/[\/&]/\\&/g')
# sed -i "\|<\/devices>|a $NEW_QEMU" /home/$CUR_USER/vm/templates/$VM

# new_string="This/Is\\nMyNewString"
# sed -i "/<\/devices>/a $NEW_QEMU" /home/$CUR_USER/vm/templates/$VM

awk -v new="$NEW_QEMU" '/<\/devices>/ {print $0 "\n" new; next} 1' /home/$CUR_USER/vm/templates/$VM > /home/$CUR_USER/vm/templates/$VM.temp && mv /home/$CUR_USER/vm/templates/$VM.temp /home/$CUR_USER/vm/templates/$VM

sudo virsh define /home/$CUR_USER/vm/templates/$VM