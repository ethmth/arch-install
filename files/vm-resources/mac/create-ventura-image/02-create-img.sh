#!/bin/bash

mkdir -p ~/installers/ventura

cd ~/installers/ventura

git clone --depth 1 https://github.com/kholia/OSX-KVM.git OSX-KVM

cd OSX-KVM/scripts

chmod +x create_dmg_ventura.sh
./create_dmg_ventura.sh

echo "If the script executed successfully, the Ventura.dmg file should be created on your desktop"
