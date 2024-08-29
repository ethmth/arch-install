#!/bin/bash

mkdir -p ~/Downloads/Voodoo

if ! [ -e "~/Downloads/Voodoo/Kext-Droplet-macOS.dmg.zip" ]; then
    wget -O ~/Downloads/Voodoo/Kext-Droplet-macOS.dmg.zip https://github.com/chris1111/Kext-Droplet-macOS/releases/download/V1/Kext-Droplet-macOS.dmg.zip
    cd ~/Downloads/Voodoo
    unzip Kext-Droplet-macOS.dmg.zip
fi

if ! [ -e "~/Downloads/Voodoo/VoodooHDA.zip" ]; then
    wget -O ~/Downloads/Voodoo/VoodooHDA.zip https://downloads.sourceforge.net/project/voodoohda/VoodooHDA.kext-v301.zip
    cd ~/Downloads/Voodoo
    unzip VoodooHDA.zip
fi

echo "Kext-Droplet-macOS.dmg and VoodooHDA.kext in ~/Downloads/Voodoo"
echo "Install Kext Droplet, then drag the Voodoo kext into the Window, then approve any System changes and restart."