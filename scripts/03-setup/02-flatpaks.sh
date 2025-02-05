#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi

CUR_USER=$(whoami)
source /home/$CUR_USER/arch-install/config/system.conf

# Install Flatpaks
# nz.mega.MEGAsync
flatpaks="
org.eclipse.Java
io.photoflare.photoflare
org.keepassxc.KeePassXC
org.cryptomator.Cryptomator
com.github.jeromerobert.pdfarranger
io.github.dman95.SASM
org.kde.kleopatra
com.github.libresprite.LibreSprite
net.scribus.Scribus
org.avidemux.Avidemux
com.logseq.Logseq
io.itch.itch
org.processing.processingide
one.flipperzero.qFlipper
com.github.PintaProject.Pinta
org.upscayl.Upscayl
io.dbeaver.DBeaverCommunity
org.filezillaproject.Filezilla
org.freecadweb.FreeCAD
org.blender.Blender
org.octave.Octave
org.raspberrypi.rpi-imager
cc.arduino.IDE2
org.gimp.GIMP
org.libreoffice.LibreOffice
org.onlyoffice.desktopeditors
app.bluebubbles.BlueBubbles
com.belmoussaoui.Decoder
com.brave.Browser
com.github.Matoking.protontricks
org.torproject.torbrowser-launcher
com.github.tchx84.Flatseal
com.google.AndroidStudio
com.heroicgameslauncher.hgl
com.jetbrains.IntelliJ-IDEA-Community
com.usebottles.bottles
com.valvesoftware.Steam
eu.scarpetta.PDFMixTool
io.gitlab.librewolf-community
net.lutris.Lutris
net.mullvad.MullvadBrowser
org.chromium.Chromium
com.google.Chrome
org.kde.kdenlive
org.signal.Signal
rest.insomnia.Insomnia
io.freetubeapp.FreeTube
org.getmonero.Monero
org.electrum.electrum
org.kde.kalgebra
org.kde.labplot2
fr.romainvigier.MetadataCleaner
org.tigervnc.vncviewer
com.jgraph.drawio.desktop
com.ultimaker.cura
fr.handbrake.ghb
org.prismlauncher.PrismLauncher
"
# if (( NVIDIA || INTEL )); then
# flatpaks+="
# org.prismlauncher.PrismLauncher
# "
# fi
# com.visualstudio.code

# GAMES
flatpaks+="
org.armagetronad.ArmagetronAdvanced
"

flatpaks=${flatpaks//$'\n'/ }
flatpaks=$(echo "$flatpaks" | tr -s ' ' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
flatpak install --noninteractive flathub $flatpaks

flatpak install --noninteractive --user https://sober.vinegarhq.org/sober.flatpakref 

#sudo -k flatpak override --reset io.gitlab.librewolf-community
#sudo flatpak override --nosocket=wayland io.gitlab.librewolf-community

sudo flatpak override org.getmonero.Monero --filesystem=~/monero-storage:create

flatpak update

echo "Verify that the installation of the flatpaks was successful"
echo "==========================================================="
echo "Note: If you have clipboard issues with the address bar of Librewolf,"
echo "consider disabling socket=wayland access in Flatseal to force xwayland"
echo "==========================================================="
echo "Disable socket=wayland access in Flatseal for DBeaver"
echo "==========================================================="
echo "If you're on Hyprland, run nwg-look and set the 'Prefer Dark' gtk theme"
# echo "==========================================================="
# echo "If you have trouble with MEGAsync, consider rolling back the version."
# echo "flatpak remote-info --log flathub nz.mega.MEGAsync"
# echo "sudo flatpak update --commit=7f30d8f2998e3376afb64525ae537f392c7b737b6209a13fc29a1610493f
# 418c nz.mega.MEGAsync"
# echo "sudo flatpak mask nz.mega.MEGAsync"
echo "==========================================================="
echo "Next, run ./03-flatpaks-no-flathub.sh"
