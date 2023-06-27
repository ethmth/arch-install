#!/bin/bash

mkdir -p ~/installers/voodoo

wget -O ~/installers/voodoo/voodoo.zip https://bitbucket.org/RehabMan/os-x-voodoo-ps2-controller/downloads/RehabMan-Voodoo-2018-1008.zip

cd ~/installers/voodoo

unzip voodoo.zip


sudo rm -rf /System/Library/Extensions/AppleACPIPS2Nub.kext
sudo rm -rf /System/Library/Extensions/ApplePS2Controller.kext
sudo rm -rf /System/Library/Extensions/ApplePS2SmartTouchPad.kext

sudo rm -rf /Library/Extensions/AppleACPIPS2Nub.kext
sudo rm -rf /Library/Extensions/ApplePS2Controller.kext
sudo rm -rf /Library/Extensions/ApplePS2SmartTouchPad.kext

sudo cp -R Release/VoodooPS2Controller.kext /Library/Extensions

sudo touch /System/Library/Extensions && sudo kextcache -u /