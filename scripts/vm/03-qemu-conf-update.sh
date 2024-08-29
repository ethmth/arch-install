#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
        echo "This script should not be run with root/sudo privileges."
        exit 1
fi

CUR_USER=$(whoami)

sudo -k bash /home/$CUR_USER/arch-install/util/kernel/config-update.sh /etc/libvirt/qemu.conf "user=\"root\""
sudo bash /home/$CUR_USER/arch-install/util/kernel/config-update.sh /etc/libvirt/qemu.conf "group=\"root\""

echo "/etc/libvirt/qemu.conf updated with correct user information."
echo "Run ./04-resources-disk.sh to create the resources disk."