#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
        echo "This script should not be run with root/sudo privileges."
        exit 1
fi

CUR_USER=$(whoami)
CUR_USER_ID=$(id -u)

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

NAME=$(cat /home/$CUR_USER/vm/templates/$VM | grep "<name>")
NAME=$(echo "$NAME" | grep -oP '(?<=<name>).*?(?=</name>)')
UUID=$(cat /home/$CUR_USER/vm/templates/$VM | grep "<uuid>")
UUID=$(echo "$UUID" | grep -oP '(?<=<uuid>).*?(?=</uuid>)')
DISK=$(cat /home/$CUR_USER/vm/templates/$VM | grep ".qcow2" | grep "file" | grep -v "OpenCore")
DISK=${DISK#*=\'}
DISK=${DISK%\'*}
DISK_OC=$(cat /home/$CUR_USER/vm/templates/$VM | grep ".qcow2" | grep "file" | grep "OpenCore")
DISK_OC=${DISK_OC#*=\'}
DISK_OC=${DISK_OC%\'*}
DISK_IMAGE=$(cat /home/$CUR_USER/vm/templates/$VM | grep ".img" | grep "file")
DISK_IMAGE=${DISK_IMAGE#*=\'}
DISK_IMAGE=${DISK_IMAGE%\'*}
MAC=$(cat /home/$CUR_USER/vm/templates/$VM | grep "<mac address=")
MAC=${MAC#*=\'}
MAC=${MAC%\'*}
NETWORK=$(cat /home/$CUR_USER/vm/templates/$VM | grep "<source network=")
NETWORK=${NETWORK#*=\'}
NETWORK=${NETWORK%\'*}
RESOURCES_DISK=$(cat /home/$CUR_USER/vm/templates/$VM | grep "resources.iso")
RESOURCES_DISK=${RESOURCES_DISK#*=\'}
RESOURCES_DISK=${RESOURCES_DISK%\'*}
DIRECTORY=$(dirname $DISK_OC)

mv /home/$CUR_USER/vm/templates/$VM /home/$CUR_USER/vm/templates/$VM.old
cp /home/$CUR_USER/arch-install/files/templates/MacOS-after.xml /home/$CUR_USER/vm/templates/$NAME.xml

sed -i "s/VIRT_NETWORK_HERE/$NETWORK/g" /home/$CUR_USER/vm/templates/$NAME.xml
sed -i "s/VIRT_MAC_ADDRESS_HERE/$MAC/g" /home/$CUR_USER/vm/templates/$NAME.xml
sed -i "s|VIRT_DISK_HERE|$DISK|g" /home/$CUR_USER/vm/templates/$NAME.xml
sed -i "s|VIRT_RESOURCESDISK_HERE|$RESOURCES_DISK|g" /home/$CUR_USER/vm/templates/$NAME.xml
sed -i "s|VIRT_OCDIR_HERE/OpenCore.qcow2|$DISK_OC|g" /home/$CUR_USER/vm/templates/$NAME.xml
sed -i "s|VIRT_ISODISK_HERE|$DISK_IMAGE|g" /home/$CUR_USER/vm/templates/$NAME.xml
sed -i "s|VIRT_OCDIR_HERE|$DIRECTORY|g" /home/$CUR_USER/vm/templates/$NAME.xml
sed -i "s/VIRT_NAME_HERE/$NAME/g" /home/$CUR_USER/vm/templates/$NAME.xml
sed -i "s/VIRT_UUID_HERE/$UUID/g" /home/$CUR_USER/vm/templates/$NAME.xml
sed -i "s/VIRT_UUID_HERE/$UUID/g" /home/$CUR_USER/vm/templates/$NAME.xml
sed -i "s/VIRT_USERID_HERE/$CUR_USER_ID/g" /home/$CUR_USER/vm/templates/$NAME.xml

sudo virsh -c qemu:///system define /home/$CUR_USER/vm/templates/$NAME.xml

chmod o+x /home/$CUR_USER
chmod o+x /home/$CUR_USER/vm
chmod o+x /home/$CUR_USER/vm/os

cd $DIRECTORY/osx-serial-generator/OSX-KVM
git restore OVMF_VARS.fd

echo "Virtual machine $NAME updated."
echo "Add your GPU to the VM, then play away."
echo "IMPORTANT: For GPU audio, add the GPU and the GPU Audio Device on the same virtual bus, just with a different function."
