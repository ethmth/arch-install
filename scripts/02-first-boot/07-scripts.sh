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
sudo mkdir -p /etc/systemd/logind.conf.d
sudo sh -c 'printf "[Login]\nHandlePowerKey=ignore\nHandlePowerKeyLongPress=poweroff\n" > /etc/systemd/logind.conf.d/20-powerbutton.conf'
sudo cp /home/$CUR_USER/arch-install/files/configs/10-no-autoadd.conf /etc/X11/xorg.conf.d/10-no-autoadd.conf
if (( LAPTOP )); then
    sudo sh -c 'printf "[Login]\nHandleLidSwitch=sleep\nHandleLidSwitchExternalPower=ignore\nHandleLidSwitchDocked=ignore\n" > /etc/systemd/logind.conf.d/10-lidswitch.conf'
    sudo cp /home/$CUR_USER/arch-install/files/configs/backlight.rules /etc/udev/rules.d/backlight.rules
fi
if (( HYPRLAND )); then
    sudo cp /home/$CUR_USER/arch-install/files/installed_scripts/wrappedhl /usr/local/bin/wrappedhl
    sudo chmod +rx /usr/local/bin/wrappedhl
    sudo cp /home/$CUR_USER/arch-install/files/installed_scripts/lock /usr/local/bin/lock
    sudo chmod +rx /usr/local/bin/lock
    sudo cp /home/$CUR_USER/arch-install/files/configs/hyprlandwrapper.desktop /usr/share/wayland-sessions/hyprlandwrapper.desktop
    sudo sh -c "printf \"[Autologin]\nUser=$CUR_USER\nSession=hyprlandwrapper\n\" > /etc/sddm.conf.d/autologin.conf"
elif (( PLASMA )); then
    if (( NVIDIA && ! INTEL )); then
        sudo sh -c "printf \"[Autologin]\nUser=$CUR_USER\nSession=plasmax11\n\" > /etc/sddm.conf.d/autologin.conf"
    else
        sudo sh -c "printf \"[Autologin]\nUser=$CUR_USER\nSession=plasma\n\" > /etc/sddm.conf.d/autologin.conf"
    fi
fi
if (( LAPTOP && HYPRLAND )); then
    sudo cp /home/$CUR_USER/arch-install/files/installed_scripts/brightlight /usr/local/bin/brightlight
    sudo chmod +rx /usr/local/bin/brightlight
fi
sudo sh -c "printf \"[Users]\nHideUsers=del_prot\n\" > /etc/sddm.conf.d/hiddenusers.conf"

sudo cp /home/$CUR_USER/arch-install/files/installed_scripts/update-resolv-conf /etc/openvpn/update-resolv-conf
sudo chmod +rx /etc/openvpn/update-resolv-conf

for src_file in "/home/$CUR_USER/arch-install/files/installed_scripts"/*; do
    file_name=$(basename "$src_file")
    sudo cp "$src_file" "/usr/local/bin/$file_name"
    sudo chmod +rx "/usr/local/bin/$file_name"
done


echo "Verify that scripts were installed correctly (sshbg, stream-dl, megasync-delay, etc)"
echo "If so, run ./08-misc.sh"
