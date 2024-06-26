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
    sudo cp /home/$CUR_USER/arch-install/files/installed_scripts/wrappedhl /usr/bin/wrappedhl
    sudo chmod +rx /usr/bin/wrappedhl
    sudo cp /home/$CUR_USER/arch-install/files/installed_scripts/lock /usr/bin/lock
    sudo chmod +rx /usr/bin/lock
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
    sudo cp /home/$CUR_USER/arch-install/files/installed_scripts/brightlight /usr/bin/brightlight
    sudo chmod +rx /usr/bin/brightlight
fi
sudo cp /home/$CUR_USER/arch-install/files/installed_scripts/update-resolv-conf /etc/openvpn/update-resolv-conf
sudo cp /home/$CUR_USER/arch-install/files/installed_scripts/sshbg /usr/bin/sshbg
sudo cp /home/$CUR_USER/arch-install/files/installed_scripts/stream-dl /usr/bin/stream-dl
sudo cp /home/$CUR_USER/arch-install/files/installed_scripts/megasync-delay /usr/bin/megasync-delay
sudo cp /home/$CUR_USER/arch-install/files/installed_scripts/docker-update /usr/bin/docker-update
sudo cp /home/$CUR_USER/arch-install/files/installed_scripts/checkmount /usr/bin/checkmount
sudo cp /home/$CUR_USER/arch-install/files/installed_scripts/txt2img /usr/bin/txt2img
sudo cp /home/$CUR_USER/arch-install/files/installed_scripts/tab2space /usr/bin/tab2space
sudo cp /home/$CUR_USER/arch-install/files/installed_scripts/xmlremove /usr/bin/xmlremove
sudo cp /home/$CUR_USER/arch-install/files/installed_scripts/git-make-like /usr/bin/git-make-like
sudo cp /home/$CUR_USER/arch-install/files/installed_scripts/pdf2png /usr/bin/pdf2png
sudo cp /home/$CUR_USER/arch-install/files/installed_scripts/nightlight /usr/bin/nightlight
sudo cp /home/$CUR_USER/arch-install/files/installed_scripts/svg2ico /usr/bin/svg2ico
sudo cp /home/$CUR_USER/arch-install/files/installed_scripts/get-cookies /usr/bin/get-cookies
sudo cp /home/$CUR_USER/arch-install/files/installed_scripts/virsh-net-start /usr/bin/virsh-net-start
sudo cp /home/$CUR_USER/arch-install/files/installed_scripts/timecode /usr/bin/timecode
sudo cp /home/$CUR_USER/arch-install/files/installed_scripts/cat-folder /usr/bin/cat-folder
sudo cp /home/$CUR_USER/arch-install/files/installed_scripts/extract-frame /usr/bin/extract-frame
sudo cp /home/$CUR_USER/arch-install/files/installed_scripts/extract-frames /usr/bin/extract-frames

sudo chmod +rx /etc/openvpn/update-resolv-conf
sudo chmod +rx /usr/bin/sshbg
sudo chmod +rx /usr/bin/stream-dl
sudo chmod +rx /usr/bin/megasync-delay
sudo chmod +rx /usr/bin/docker-update
sudo chmod +rx /usr/bin/checkmount
sudo chmod +rx /usr/bin/txt2img
sudo chmod +rx /usr/bin/tab2space
sudo chmod +rx /usr/bin/xmlremove
sudo chmod +rx /usr/bin/git-make-like
sudo chmod +rx /usr/bin/pdf2png
sudo chmod +rx /usr/bin/nightlight
sudo chmod +rx /usr/bin/svg2ico
sudo chmod +rx /usr/bin/get-cookies
sudo chmod +rx /usr/bin/virsh-net-start
sudo chmod +rx /usr/bin/timecode
sudo chmod +rx /usr/bin/cat-folder
sudo chmod +rx /usr/bin/extract-frame
sudo chmod +rx /usr/bin/extract-frames

echo "Verify that scripts were installed correctly (sshbg, stream-dl, megasync-delay, etc)"
echo "If so, run ./09-initcpio.sh"
