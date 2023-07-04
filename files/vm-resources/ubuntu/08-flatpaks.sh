#!/bin/bash

if [[ $EUID -ne 0 ]]; then
	echo "This script should be run with root/sudo privileges."
	exit 1
fi

flatpak remote-add --if-not-exists --no-gpg-verify flathub https://flathub.org/repo/flathub.flatpakrepo

# Install Flatpaks
flatpaks="
org.gimp.GIMP
com.brave.Browser
com.github.micahflee.torbrowser-launcher
com.github.tchx84.Flatseal
io.gitlab.librewolf-community
net.mullvad.MullvadBrowser
nz.mega.MEGAsync
org.chromium.Chromium
org.jdownloader.JDownloader
com.obsproject.Studio
org.filezillaproject.Filezilla
network.loki.Session
org.cryptomator.Cryptomator
com.opera.Opera
"

flatpaks=${flatpaks//$'\n'/ }
flatpaks=$(echo "$flatpaks" | tr -s ' ' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
flatpak install --noninteractive flathub $flatpaks

flatpak update

echo "Verify that the installation of the flatpaks was successful"
