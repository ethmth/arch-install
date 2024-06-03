#!/bin/bash

if [[ $EUID -ne 0 ]]; then
	echo "This script should be run with root/sudo privileges."
	exit 1
fi

flatpak remote-add --if-not-exists --no-gpg-verify flathub https://flathub.org/repo/flathub.flatpakrepo

# Install Flatpaks
# org.jdownloader.JDownloader
flatpaks="
org.kde.kleopatra
io.github.java_decompiler.jd-gui
fr.handbrake.ghb
org.avidemux.Avidemux
org.getmonero.Monero
org.gimp.GIMP
com.brave.Browser
org.torproject.torbrowser-launcher
com.github.tchx84.Flatseal
io.gitlab.librewolf-community
net.mullvad.MullvadBrowser
nz.mega.MEGAsync
com.tonikelope.MegaBasterd
com.obsproject.Studio
org.telegram.desktop
network.loki.Session
org.cryptomator.Cryptomator
com.opera.Opera
io.github.seadve.Kooha
org.gajim.Gajim
fr.romainvigier.MetadataCleaner
"
#com.vscodium.codium

flatpaks=${flatpaks//$'\n'/ }
flatpaks=$(echo "$flatpaks" | tr -s ' ' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
flatpak install --noninteractive flathub $flatpaks

flatpak override org.getmonero.Monero --filesystem=~/monero-storage:create

flatpak update

echo "Verify that the installation of the flatpaks was successful"
echo "Add KOOHA_EXPERIMENTAL=1 to env variables for io.github.seadve.Kooha for window recording"
echo "==========================================================="
echo "If you have trouble with MEGAsync, consider rolling back the version."
echo "flatpak remote-info --log flathub nz.mega.MEGAsync"
echo "sudo flatpak update --commit=7f30d8f2998e3376afb64525ae537f392c7b737b6209a13fc29a1610493f
418c nz.mega.MEGAsync"
echo "sudo flatpak mask nz.mega.MEGAsync"
echo "==========================================================="
