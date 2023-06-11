#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
        echo "This script should not be run with root/sudo privileges."
        exit 1
fi

CUR_USER=$(whoami)
mkdir -p /home/$CUR_USER/vm/tools

git clone https://github.com/pavolelsig/evdev_helper.git /home/$CUR_USER/vm/tools/evdev_helper

cd /home/$CUR_USER/vm/tools/evdev_helper

chmod +x run_ev_helper.sh

sudo -k ./run_ev_helper.sh

echo "Results in /home/$CUR_USER/vm/tools/evdev_helper/evdev.txt"
echo "Run ./03-qemu-conf-update.sh to put the correct user in /etc/libvirt/qemu.conf"