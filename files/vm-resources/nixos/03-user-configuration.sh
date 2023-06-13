#!/bin/bash

gnome-extensions enable dash-to-dock@micxgx.gmail.com
gnome-extensions enable gsconnect@andyholmes.github.io

gsettings set org.gnome.desktop.interface gtk-theme Yaru-dark
gsettings set org.gnome.desktop.interface color-scheme prefer-dark

gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'
gsettings set org.gnome.desktop.session idle-delay 0
