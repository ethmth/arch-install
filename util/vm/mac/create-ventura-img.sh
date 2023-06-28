#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
        echo "This script should not be run with root/sudo privileges."
        exit 1
fi

CUR_USER=$(whoami)


if [ -e "/home/$CUR_USER/vm/os/macos-Ventura.img" ]; then
    echo "/home/$CUR_USER/vm/os/macos-Ventura.img already exists"
    exit 1
fi

if ! [ -e "/home/$CUR_USER/vm/osx/Ventura.dmg" ]; then
    echo "/home/$CUR_USER/vm/osx/Ventura.dmg does not exist"
    echo "Be sure you've run through the Mac-side setup."
    exit 1
fi

#dmg2img -i /home/$CUR_USER/vm/osx/Ventura.dmg /home/$CUR_USER/vm/os/macos-Ventura.img

#echo "If dmg2img says dmg is corrupted, try just renameing the dmg file to an img"
mv /home/$CUR_USER/vm/osx/Ventura.dmg /home/$CUR_USER/vm/os/macos-Ventura.img

echo "/home/$CUR_USER/vm/os/macos-Ventura.img created"
