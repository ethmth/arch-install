#!/bin/bash

# Load Config Values
CUR_USER=$(whoami)
echo "$CUR_USER"
source /home/$CUR_USER/install-scripts/values.conf

# Software Specific Configuration
sudo -k mkdir /etc/systemd/system.conf.d
sudo sh -c 'printf "[Manager]\nDefaultTimeoutStopSec=25s\n" > /etc/systemd/system.conf.d/10-timeout.conf'
if (( LAPTOP )); then
    sudo mkdir /etc/systemd/login.conf.d
    sudo sh -c 'printf "[Login]\nHandleLidSwitch=sleep\nHandleLidSwitchExternalPower=ignore\nHandleLidSwitchDocked=ignore\n" > /etc/systemd/logind.conf.d/10-lidswitch.conf'
    sudo cp /home/$CUR_USER/install-scripts/configs/backlight.rules /etc/udev/rules.d/backlight.rules
fi
if (( HYPRLAND )); then
    sudo cp /home/$CUR_USER/install-scripts/installed_scripts/wrappedhl /usr/bin/wrappedhl
    sudo cp /home/$CUR_USER/install-scripts/configs/hyprlandwrapper.desktop /usr/share/wayland-sessions/hyprlandwrapper.desktop
    sudo sh -c "printf \"[Autologin]\nUser=$CUR_USER\nSession=hyprlandwrapper\n\" > /etc/sddm.conf"
fi
if (( LAPTOP && HYPRLAND )); then
    sudo cp /home/$CUR_USER/install-scripts/installed_scripts/brightlight /usr/bin/brightlight
    sudo cp /home/$CUR_USER/install-scripts/installed_scripts/nightlight /usr/bin/nightlight
fi
if (( PLASMA )); then
    sudo sh -c "printf \"[Autologin]\nUser=$CUR_USER\nSession=plasmawayland\n\" > /etc/sddm.conf"
fi
sudo cp /home/$CUR_USER/install-scripts/installed_scripts/update-resolv-conf /etc/openvpn/update-resolv-conf
sudo cp /home/$CUR_USER/install-scripts/installed_scripts/sshbg /usr/bin/sshbg
sudo cp /home/$CUR_USER/install-scripts/installed_scripts/stream-dl /usr/bin/stream-dl
sudo cp /home/$CUR_USER/install-scripts/installed_scripts/megasync /usr/bin/megasync

# Enable Services
sudo systemctl enable sddm.service
sudo systemctl enable libvirtd
sudo systemctl enable cronie
sudo systemctl enable docker
sudo systemctl enable sshd
sudo systemctl enable cups
if (( LAPTOP )); then
    sudo systemctl enable auto-cpufreq
fi