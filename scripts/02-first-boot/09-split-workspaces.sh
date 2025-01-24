#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi

CUR_USER=$(whoami)
source /home/$CUR_USER/arch-install/config/system.conf
source /home/$CUR_USER/arch-install/config/network-interface.conf

if (( HYPRLAND )); then
    if [ -f "/opt/hyprland/split-monitor-workspaces/split-monitor-workspaces.so" ]; then
        echo "Note: Delete /opt/hyprland/split-monitor-workspaces/split-monitor-workspaces.so to rebuild."
    else
        sudo mkdir -p /opt/hyprland
        sudo chmod -R 777 /opt/hyprland
        if [ -d "/opt/hyprland/hyprland" ]; then
            rm -rf /opt/hyprland/hyprland
        fi
        git clone --recurse-submodules https://github.com/hyprwm/Hyprland.git /opt/hyprland/hyprland
        cd /opt/hyprland/hyprland
        GIT_HYPRLAND_VERSION="v$(yay -Q hyprland | cut -d ' ' -f 2 | cut -d '-' -f 1)"
        git checkout $GIT_HYPRLAND_VERSION
        make all
        
        #if [ -d "/opt/hyprland/wlr" ]; then
        #    rm -rf /opt/hyprland/wlr
        #fi
        #cp -r /usr/include/wlr /opt/hyprland
        #cp /usr/include/hyprland/wlroots-hyprland/wlr/util/transform.h /opt/hyprland/wlr/util/transform.h

        if [ -d "/opt/hyprland/split-monitor-workspaces" ]; then
            rm -rf /opt/hyprland/split-monitor-workspaces
        fi
        git clone https://github.com/ethmth/split-monitor-workspaces.git /opt/hyprland/split-monitor-workspaces
        cd /opt/hyprland/split-monitor-workspaces
        #git checkout c75ec3a643a98169acdea03336c06f3656fe0e76
        export HYPRLAND_HEADERS="/opt/hyprland"
        INCLUDE_PATH_LINE="COMPILE_FLAGS+=-I/opt/hyprland"
        sed -i "/COMPILE_FLAGS+=/a $INCLUDE_PATH_LINE" Makefile
        make all
    fi
fi

echo "Run ./10-initcpio.sh"
