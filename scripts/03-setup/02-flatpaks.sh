#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi

CUR_USER=$(whoami)
source /home/$CUR_USER/arch-install/config/system.conf

# Install Flatpaks
flatpaks="
app.bluebubbles.BlueBubbles
com.belmoussaoui.Decoder
com.brave.Browser
com.github.Matoking.protontricks
com.github.micahflee.torbrowser-launcher
com.github.tchx84.Flatseal
com.google.AndroidStudio
com.heroicgameslauncher.hgl
com.jetbrains.IntelliJ-IDEA-Community
com.usebottles.bottles
com.valvesoftware.Steam
eu.scarpetta.PDFMixTool
io.gitlab.librewolf-community
net.davidotek.pupgui2
net.lutris.Lutris
net.mullvad.MullvadBrowser
nz.mega.MEGAsync
org.chromium.Chromium
org.kde.kdenlive
org.signal.Signal
rest.insomnia.Insomnia
"
if (( NVIDIA || INTEL )); then
flatpaks+="
org.prismlauncher.PrismLauncher
"
fi

flatpaks=${flatpaks//$'\n'/ }
flatpaks=$(echo "$flatpaks" | tr -s ' ' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
flatpak install --noninteractive flathub $flatpaks
flatpak update

echo "Verify that the installation of the flatpaks was successful"
echo "If so, run ./03-openair-clone.sh"
