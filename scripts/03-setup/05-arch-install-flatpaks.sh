#!/bin/bash

# Load Config Values
CUR_USER=$(whoami)
source /home/$CUR_USER/install-scripts/values.conf

# Install Flatpaks
flatpaks="
com.brave.Browser
com.github.micahflee.torbrowser-launcher
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
nz.mega.MEGAsync
org.chromium.Chromium
org.kde.kdenlive
rest.insomnia.Insomnia
org.signal.Signal
com.github.Matoking.protontricks
com.belmoussaoui.Decoder
app.bluebubbles.BlueBubbles
net.davidotek.pupgui2
"
if (( NVIDIA || INTEL )); then
flatpaks+="
org.prismlauncher.PrismLauncher
"
fi

flatpaks=${flatpaks//$'\n'/ }
flatpaks=$(echo "$flatpaks" | tr -s ' ' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
flatpak install --noninteractive flathub $flatpaks
