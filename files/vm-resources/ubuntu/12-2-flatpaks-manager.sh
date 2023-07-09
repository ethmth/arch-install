#!/bin/bash

if [[ $EUID -ne 0 ]]; then
	echo "This script should be run with root/sudo privileges."
	exit 1
fi

flatpak remote-add --if-not-exists --no-gpg-verify flathub https://flathub.org/repo/flathub.flatpakrepo

flatpaks="
com.google.AndroidStudio
com.obsproject.Studio
"

flatpaks=${flatpaks//$'\n'/ }
flatpaks=$(echo "$flatpaks" | tr -s ' ' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
flatpak install --noninteractive flathub $flatpaks

flatpak update

echo "Verify that the installation of the flatpaks was successful"
