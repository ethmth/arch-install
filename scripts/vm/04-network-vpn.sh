#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi

CUR_USER=$(whoami)

# Setup VPN-Gateway network
sudo -k virsh -c qemu:///system net-define /home/$CUR_USER/arch-install/files/templates/VPN-Gateway.xml
sudo virsh -c qemu:///system net-autostart VPN-Gateway
sudo virsh -c qemu:///system net-start VPN-Gateway

echo "VPN-Gateway should have been successfully defined"
echo "If you haven't yet, you may want to setup vfio by running the ../06-vfio/ scripts"
echo "Otherwise, you may want to setup Whonix by running the ../07-whonix/ scripts."