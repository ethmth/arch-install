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
sudo systemctl enable reflector.service
sudo systemctl enable reflector.timer
sudo systemctl enable docker
sudo systemctl enable sshd
# sudo systemctl enable redis
sudo systemctl enable cups
sudo systemctl enable paccache.timer
sudo systemctl enable fstrim.timer
sudo systemctl enable etckeeper.timer
sudo systemctl enable ntpd.service
sudo systemctl enable avahi-daemon.service
if (( LAPTOP )); then
    sudo systemctl enable auto-cpufreq
fi
if (( NVIDIA && ! INTEL)); then
	sudo systemctl enable nvidia-suspend.service
	sudo systemctl enable nvidia-hibernate.service
	sudo systemctl enable nvidia-resume.service
fi
# Disable Sleeping
sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target

# Disable KDE Powerdevil
# systemctl --user mask plasma-powerdevil.service

sudo git config --global user.email "root"
sudo git config --global user.name "root"
if ! [ -d "/etc/.git" ]; then
	sudo etckeeper init
	sudo etckeeper commit "first commit"
fi

echo "Verify that the enabling of the systemd services was successful"
echo "If so, run ./05-groups.sh"
