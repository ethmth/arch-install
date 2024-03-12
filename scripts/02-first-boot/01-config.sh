#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
        echo "This script should not be run with root/sudo privileges."
        exit 1
fi

CUR_USER=$(whoami)
OFILE="/home/$CUR_USER/arch-install/config/system.conf"

typeofcpu=$(printf "Desktop\nLaptop\n" | fzf --prompt="Select your type of computer")
if [ "$typeofcpu" == "" ]; then
    echo "Exiting. No action taken."
    exit 1
fi

cpu=$(printf "AMD\nIntel\n" | fzf --prompt="Select your CPU")
if [ "$cpu" == "" ]; then
    echo "Exiting. No action taken."
    exit 1
fi
gpu=$(printf "AMD GPU\nIntel Integrated Graphics\nNvidia GPU\n" | fzf -m --prompt="Select your host GPU(s). All but what you passthrough")
if [ "$gpu" == "" ]; then
    echo "Exiting. No action taken."
    exit 1
fi
de=$(printf "Hyprland\nKDE Plasma\n" | fzf -m --prompt="Select your preferred Desktop Environment")
if [ "$de" == "" ]; then
    echo "Exiting. No action taken."
    exit 1
fi

INTERFACE=$(ls -1 /sys/class/net | grep -v "lo" | grep -v "docker" | grep -v "virbr" | grep -v "vnet" | fzf --prompt "Please select your primary network interface")
if [ "$INTERFACE" == "" ]; then
    echo "Exiting. No action taken."
    exit 1
fi
OFILE_INTERFACE="/home/$CUR_USER/arch-install/config/network-interface.conf"

DESKTOP=0
LAPTOP=0
AMD_CPU=0
INTEL_CPU=0
AMD=0
INTEL=0
NVIDIA=0
HYPRLAND=0
PLASMA=0

if [[ $typeofcpu == *"Desktop"* ]]; then
    DESKTOP=1
fi
if [[ $typeofcpu == *"Laptop"* ]]; then
    LAPTOP=1
fi

if [[ $cpu == *"AMD"* ]]; then
    AMD_CPU=1
fi
if [[ $cpu == *"Intel"* ]]; then
    INTEL_CPU=1
fi

if [[ $gpu == *"AMD GPU"* ]]; then
    AMD=1
fi
if [[ $gpu == *"Intel Integrated Graphics"* ]]; then
    INTEL=1
fi
if [[ $gpu == *"Nvidia GPU"* ]]; then
    NVIDIA=1
fi

if [[ $de == *"Hyprland"* ]]; then
    HYPRLAND=1
fi
if [[ $de == *"KDE Plasma"* ]]; then
    PLASMA=1
fi

echo "DESKTOP=$DESKTOP" > $OFILE
echo "LAPTOP=$LAPTOP" >> $OFILE
echo "AMD_CPU=$AMD_CPU" >> $OFILE
echo "INTEL_CPU=$INTEL_CPU" >> $OFILE
echo "AMD=$AMD" >> $OFILE
echo "INTEL=$INTEL" >> $OFILE
echo "NVIDIA=$NVIDIA" >> $OFILE
echo "HYPRLAND=$HYPRLAND" >> $OFILE
echo "PLASMA=$PLASMA" >> $OFILE

echo "NETWORK_INTERFACE=$INTERFACE" > $OFILE_INTERFACE

echo "system.conf:"
cat $OFILE
echo ""
echo "network-interface.conf:"
cat $OFILE_INTERFACE

echo "Verify the contents of $OFILE and network-interface.conf (Output above)"
echo "You can manually edit $OFILE with 1 or 0 if needed"
echo "If successful, run ./02-yay.sh"
