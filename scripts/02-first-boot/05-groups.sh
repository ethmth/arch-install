#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi

CUR_USER=$(whoami)
source /home/$CUR_USER/arch-install/config/system.conf

sudo -k groupadd autologin
sudo usermod -aG network,libvirt,kvm,input,docker,wireshark,autologin,render $CUR_USER
# sudo usermod -aG libvirt-qemu $CUR_USER

# Add del_prot user if it doesn't exist yet
id -u del_prot &>/dev/null || sudo useradd del_prot

groups $CUR_USER

echo "Verify that you were added to the correct groups"
echo "If so, run ./06-dotfiles.sh"