#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi

CUR_USER=$(whoami)
source /home/$CUR_USER/arch-install/config/system.conf

# Software Specific Configuration
sudo -k mkdir -p /etc/systemd/system.conf.d
sudo mkdir -p /etc/sddm.conf.d
sudo sh -c 'printf "[Manager]\nDefaultTimeoutStopSec=25s\n" > /etc/systemd/system.conf.d/10-timeout.conf'
if (( LAPTOP )); then
    sudo mkdir -p /etc/systemd/logind.conf.d
    sudo sh -c 'printf "[Login]\nHandleLidSwitch=sleep\nHandleLidSwitchExternalPower=ignore\nHandleLidSwitchDocked=ignore\n" > /etc/systemd/logind.conf.d/10-lidswitch.conf'
    sudo cp /home/$CUR_USER/arch-install/files/configs/backlight.rules /etc/udev/rules.d/backlight.rules
fi
if (( HYPRLAND )); then
    sudo cp /home/$CUR_USER/arch-install/files/installed_scripts/wrappedhl /usr/bin/wrappedhl
    sudo chmod +x /usr/bin/wrappedhl
    sudo cp /home/$CUR_USER/arch-install/files/configs/hyprlandwrapper.desktop /usr/share/wayland-sessions/hyprlandwrapper.desktop
    sudo sh -c "printf \"[Autologin]\nUser=$CUR_USER\nSession=hyprlandwrapper\n\" > /etc/sddm.conf.d/autologin.conf"
elif (( PLASMA )); then
    if (( NVIDIA && ! INTEL )); then
        sudo sh -c "printf \"[Autologin]\nUser=$CUR_USER\nSession=plasma\n\" > /etc/sddm.conf.d/autologin.conf"
    else
        sudo sh -c "printf \"[Autologin]\nUser=$CUR_USER\nSession=plasmawayland\n\" > /etc/sddm.conf.d/autologin.conf"
    fi
fi
if (( LAPTOP && HYPRLAND )); then
    sudo cp /home/$CUR_USER/arch-install/files/installed_scripts/brightlight /usr/bin/brightlight
    sudo cp /home/$CUR_USER/arch-install/files/installed_scripts/nightlight /usr/bin/nightlight
    sudo chmod +x /usr/bin/brightlight
    sudo chmod +x /usr/bin/nightlight
fi
sudo cp /home/$CUR_USER/arch-install/files/installed_scripts/update-resolv-conf /etc/openvpn/update-resolv-conf
sudo cp /home/$CUR_USER/arch-install/files/installed_scripts/sshbg /usr/bin/sshbg
sudo cp /home/$CUR_USER/arch-install/files/installed_scripts/stream-dl /usr/bin/stream-dl
sudo cp /home/$CUR_USER/arch-install/files/installed_scripts/megasync /usr/bin/megasync
sudo cp /home/$CUR_USER/arch-install/files/installed_scripts/docker-update /usr/bin/docker-update

sudo chmod +x /etc/openvpn/update-resolv-conf
sudo chmod +x /usr/bin/sshbg
sudo chmod +x /usr/bin/stream-dl
sudo chmod +x /usr/bin/megasync
sudo chmod +x /usr/bin/docker-update

echo "Verify that scripts were installed correctly (sshbg, stream-dl, megasync, etc)"
echo "If so, run ./09-grub.sh"
