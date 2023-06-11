#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
        echo "This script should not be run with root/sudo privileges."
        exit 1
fi

CUR_USER=$(whoami)

if ! [ -e "/home/$CUR_USER/vm/tools/evdev_helper/evdev.txt" ]; then
    echo "/home/$CUR_USER/vm/tools/evdev_helper/evdev.txt doesn't exist"
    echo "Please be sure you've run /evdev-setup.sh"
    exit 1
fi

VM=$(ls -1 /etc/libvirt/qemu | grep ".xml" | fzf --prompt="Select the VM you'd like to update")

if ([ "$VM" == "" ] || [ "$VM" == "Nothing" ]); then
    echo "Nothing selected."
    exit 1
fi

if ! [ -e "/etc/libvirt/qemu/$VM" ]; then
    echo "Invalid file selected"
    exit 1
fi

sudo -k cp /etc/libvirt/qemu/$VM /home/$CUR_USER/vm/templates/$VM

# sed -i '/<domain/,$!d' /home/$CUR_USER/vm/templates/$VM

NAME=$(cat /home/$CUR_USER/vm/templates/$VM | grep "<name>")
NAME=$(echo "$NAME" | grep -oP '(?<=<name>).*?(?=</name>)')
UUID=$(cat /home/$CUR_USER/vm/templates/$VM | grep "<uuid>")
UUID=$(echo "$UUID" | grep -oP '(?<=<uuid>).*?(?=</uuid>)')
DISK=$(cat /home/$CUR_USER/vm/templates/$VM | grep ".qcow2" | grep "file")
DISK=${DISK#*=\'}
DISK=${DISK%\'*}
MAC=$(cat /home/$CUR_USER/vm/templates/$VM | grep "<mac address=")
MAC=${MAC#*=\'}
MAC=${MAC%\'*}
NETWORK=$(cat /home/$CUR_USER/vm/templates/$VM | grep "<source network=")
NETWORK=${NETWORK#*=\'}
NETWORK=${NETWORK%\'*}

mv /home/$CUR_USER/vm/templates/$VM /home/$CUR_USER/vm/templates/$VM.old
cp /home/$CUR_USER/arch-install/files/templates/Windows-after.xml /home/$CUR_USER/vm/templates/$NAME.xml

NEW_QEMU=$(cat /home/$CUR_USER/vm/tools/evdev_helper/evdev.txt | grep . | grep -v "<domain")

sed -i "s/VIRT_NETWORK_HERE/$NETWORK/g" /home/$CUR_USER/vm/templates/$NAME.xml
sed -i "s/VIRT_MAC_ADDRESS_HERE/$MAC/g" /home/$CUR_USER/vm/templates/$NAME.xml
sed -i "s|VIRT_DISK_HERE|$DISK|g" /home/$CUR_USER/vm/templates/$NAME.xml
# sed -i "s|VIRT_ISODISK_HERE|$OS_DISK|g" /home/$CUR_USER/vm/templates/$NAME.xml
# sed -i "s|VIRT_RESOURCESDISK_HERE|$RESOURCES_DISK|g" /home/$CUR_USER/vm/templates/$NAME.xml
sed -i "s/VIRT_NAME_HERE/$NAME/g" /home/$CUR_USER/vm/templates/$NAME.xml
sed -i "s/VIRT_UUID_HERE/$UUID/g" /home/$CUR_USER/vm/templates/$NAME.xml
# sed -i "s|VIRT_EVDEV_HERE|$NEW_QEMU|g" /home/$CUR_USER/vm/templates/$NAME.xml

awk -v new="$NEW_QEMU" '/VIRT_EVDEV_HERE/ {print $0 "\n" new; next} 1' /home/$CUR_USER/vm/templates/$VM > /home/$CUR_USER/vm/templates/$VM.temp && mv /home/$CUR_USER/vm/templates/$VM.temp /home/$CUR_USER/vm/templates/$VM
sed -i '/VIRT_EVDEV_HERE/d' /home/$CUR_USER/vm/templates/$VM

sudo virsh -c qemu:///system define /home/$CUR_USER/vm/templates/$NAME.xml

chmod o+x /home/$CUR_USER
chmod o+x /home/$CUR_USER/vm
chmod o+x /home/$CUR_USER/vm/os

echo "Virtual machine $NAME updated."
echo "Add your GPU to the VM, then play away."