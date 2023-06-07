#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi

CUR_USER=$(whoami)
source /home/$CUR_USER/arch-install/config/system.conf

# Enable Services
sudo systemctl enable sddm.service
sudo systemctl enable libvirtd
sudo systemctl enable virtlogd.socket
sudo systemctl enable cronie
sudo systemctl enable docker
sudo systemctl enable podman
sudo systemctl enable sshd
sudo systemctl enable cups
if (( LAPTOP )); then
    sudo systemctl enable auto-cpufreq
fi

echo "Verify that the enabling of the systemd services was successful"
echo "If so, run ./05-groups.sh"