#!/bin/bash

if [[ $EUID -ne 0 ]]; then
	echo "This script should be run with root/sudo privileges."
	exit 1
fi

virsh -c qemu:///system net-autostart default
virsh -c qemu:///system net-start default

echo "If the default network started successfully,"
# echo "Mount the drive you want to use for VM installation"
echo "Run ./03-network-vpn.sh to define the VPN-Gateway network"