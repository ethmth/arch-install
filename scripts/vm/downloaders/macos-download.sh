#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi

CUR_USER=$(whoami)
mkdir -p /home/$CUR_USER/vm/osx

if ! [ -d "/home/$CUR_USER/vm/osx/OSX-KVM" ]; then
    git clone --depth 1 --recursive https://github.com/kholia/OSX-KVM.git /home/$CUR_USER/vm/osx/OSX-KVM
else
    echo "Using existing /home/$CUR_USER/vm/osx/OSX-KVM directory"
    echo "If you'd like to reset, rm -rf /home/$CUR_USER/vm/osx/OSX-KVM"
fi

python /home/$CUR_USER/vm/osx/OSX-KVM/fetch-macOS-v2.py

mv BaseSystem.dmg /home/$CUR_USER/vm/osx/OSX-KVM/BaseSystem.dmg

dmg2img -i /home/$CUR_USER/vm/osx/OSX-KVM/BaseSystem.dmg /home/$CUR_USER/vm/osx/OSX-KVM/BaseSystem.img
mv BaseSystem.chunklist /home/$CUR_USER/vm/osx/OSX-KVM/BaseSystem.chunklist

mkdir -p /home/$CUR_USER/vm/os
cp /home/$CUR_USER/vm/osx/OSX-KVM/BaseSystem.img /home/$CUR_USER/vm/os/macos.img

echo "OSX-KVM Download Complete"
