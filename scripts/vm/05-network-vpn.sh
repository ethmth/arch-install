#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi

CUR_USER=$(whoami)

# Setup VPN-Gateway network
if ! ( virsh net-list | grep -q "VPN-Gateway" ); then
	sudo -k virsh -c qemu:///system net-define /home/$CUR_USER/arch-install/files/templates/VPN-Gateway.xml
	sudo virsh -c qemu:///system net-autostart VPN-Gateway
	sudo virsh -c qemu:///system net-start VPN-Gateway
fi

echo "VPN-Gateway should have been successfully defined"
echo "Define ./07-network-vpn-internal.sh"