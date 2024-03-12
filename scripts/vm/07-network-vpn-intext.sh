#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi

CUR_USER=$(whoami)

# Setup VPN-Internal network
if ! ( virsh net-list | grep -q "VPN-Internal" ); then
sudo virsh -c qemu:///system net-define /home/$CUR_USER/arch-install/files/templates/VPN-Internal.xml
sudo virsh -c qemu:///system net-autostart VPN-Internal
sudo virsh -c qemu:///system net-start VPN-Internal
fi

if ! ( virsh net-list | grep -q "VPN-External" ); then
sudo virsh -c qemu:///system net-define /home/$CUR_USER/arch-install/files/templates/VPN-External.xml
sudo virsh -c qemu:///system net-autostart VPN-External
sudo virsh -c qemu:///system net-start VPN-External
fi

echo "VPN-Internal and VPN-External should have been successfully defined"
echo "If you haven't yet, you may want to setup vfio by running the ../10-vfio/ scripts"
echo "Otherwise, you may want to setup Whonix by running the ../11-whonix/ scripts."
echo "Alternatively, define a bridged network using ./08-network-bridged.sh (WORK IN PROGRESS)"