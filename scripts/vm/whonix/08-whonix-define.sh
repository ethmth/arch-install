#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi

CUR_USER=$(whoami)
source /home/$CUR_USER/arch-install/config/vm.conf

if [ "$WHONIX_LOC" == "" ]; then
	echo "Whonix location not set in /home/$CUR_USER/arch-install/config/vm.conf"
	echo "Run ./04-vm-config.sh first to set location"
	exit 1
fi

if ! [ -d "$WHONIX_LOC" ]; then
    echo "Your configured location is not available. Is the disk mounted?"
	echo "Try mounting the disk, and optionally running ./04-vm-config.sh"
	exit 1
fi

sudo -k virsh -c qemu:///system net-define $WHONIX_LOC/whonix/Whonix_external.xml
sudo virsh -c qemu:///system net-define $WHONIX_LOC/whonix/Whonix_internal.xml
sudo virsh -c qemu:///system net-autostart Whonix-External
sudo virsh -c qemu:///system net-start Whonix-External
sudo virsh -c qemu:///system net-autostart Whonix-Internal
sudo virsh -c qemu:///system net-start Whonix-Internal
sudo virsh -c qemu:///system define $WHONIX_LOC/whonix/Whonix-Gateway.xml
sudo virsh -c qemu:///system define $WHONIX_LOC/whonix/Whonix-Workstation.xml

echo "Virtual machines defined and started. You can now use the Whonix VMs"
echo "To continue VM setup, run ./09-network-mine.sh"