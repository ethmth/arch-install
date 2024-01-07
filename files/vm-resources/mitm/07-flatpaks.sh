#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi


# Install Flatpaks
flatpaks="
io.github.java_decompiler.jd-gui
com.google.AndroidStudio
"

flatpaks=${flatpaks//$'\n'/ }
flatpaks=$(echo "$flatpaks" | tr -s ' ' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
flatpak install --noninteractive flathub $flatpaks

flatpak update
