#!/bin/bash

if [[ $EUID -ne 0 ]]; then
	echo "This script must not be run with root/sudo privileges."
	exit 1
fi

gnome-extensions enable dash-to-dock@micxgx.gmail.com
gnome-extensions enable gsconnect@andyholmes.github.io

gsettings set org.gnome.desktop.interface gtk-theme Yaru-dark
gsettings set org.gnome.desktop.interface color-scheme prefer-dark

gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'
gsettings set org.gnome.desktop.session idle-delay 0

sudo ln -s /run/current-system/sw/bin/bash /bin/bash