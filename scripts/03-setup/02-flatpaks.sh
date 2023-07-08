#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi

CUR_USER=$(whoami)
source /home/$CUR_USER/arch-install/config/system.conf

# Install Flatpaks
flatpaks="
org.gnome.SimpleScan
org.freecadweb.FreeCAD
org.blender.Blender
org.octave.Octave
org.raspberrypi.rpi-imager
cc.arduino.IDE2
org.godotengine.Godot
org.gimp.GIMP
org.libreoffice.LibreOffice
org.onlyoffice.desktopeditors
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
io.freetubeapp.FreeTube
org.getmonero.Monero
"
if (( NVIDIA || INTEL )); then
flatpaks+="
org.prismlauncher.PrismLauncher
"
fi

flatpaks=${flatpaks//$'\n'/ }
flatpaks=$(echo "$flatpaks" | tr -s ' ' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
flatpak install --noninteractive flathub $flatpaks

#sudo -k flatpak override --reset io.gitlab.librewolf-community
#sudo flatpak override --nosocket=wayland io.gitlab.librewolf-community
flatpak update

echo "Verify that the installation of the flatpaks was successful"
echo "Note: If you have clipboard issues with the address bar of Librewolf,"
echo "consider disabling socket=wayland access in Flatseal to force xwayland"
echo "If you're on Hyprland, run nwg-look and set the 'Prefer Dark' gtk theme"
echo "Next, run ./03-openair-clone.sh"
