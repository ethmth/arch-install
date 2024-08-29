#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should NOT be run with root/sudo privileges."
	exit 1
fi

CUR_USER=$(whoami)
source /home/$CUR_USER/arch-install/config/system.conf

if (( NVIDIA && HYPRLAND && ! INTEL)); then
    sudo sh -c 'echo "options nvidia NVreg_RegistryDwords=\"PowerMizerEnable=0x1; PerfLevelSrc=0x2222; PowerMizerLevel=0x3; PowerMizerDefault=0x3; PowerMizerDefaultAC=0x3\"" > /etc/modprobe.d/nvidia.conf'

    cat /etc/modprobe.d/nvidia.conf
else
    echo "No action needed"
fi
