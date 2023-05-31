#!/bin/bash

typeofcpu=$(printf "Desktop\nLaptop\n" | fzf --prompt="Select your type of computer")
cpu=$(printf "AMD\nIntel\n" | fzf --prompt="Select your CPU")
gpu=$(printf "AMD GPU\nIntel Integrated Graphics\nNvidia GPU\n" | fzf --prompt="Select your host GPU")
de=$(printf "Hyprland\nKDE Plasma\n" | fzf --prompt="Select your preferred Desktop Environment")

DESKTOP=0
LAPTOP=0
AMD_CPU=0
INTEL_CPU=0
AMD=0
INTEL=0
NVIDIA=0
HYPRLAND=0
PLASMA=0
if [ "$typeofcpu" == "Laptop" ]; then
    LAPTOP=1
else
    DESKTOP=1
fi
if [ "$cpu" == "AMD" ]; then
    AMD_CPU=1
else
    INTEL_CPU=1
fi
if [ "$gpu" == "Nvidia GPU" ]; then
    NVIDIA=1
elif [ "$gpu" == "AMD GPU" ]; then
    AMD=1
else
    INTEL=1
fi
if [ "$de" == "Hyprland" ]; then
    HYPRLAND=1
else
    PLASMA=1
fi

CUR_USER=$(whoami)
echo "DESKTOP=$DESKTOP" > /home/$CUR_USER/install-scripts/values.conf
echo "LAPTOP=$LAPTOP" >> /home/$CUR_USER/install-scripts/values.conf
echo "AMD_CPU=$AMD_CPU" >> /home/$CUR_USER/install-scripts/values.conf
echo "INTEL_CPU=$INTEL_CPU" >> /home/$CUR_USER/install-scripts/values.conf
echo "AMD=$AMD" >> /home/$CUR_USER/install-scripts/values.conf
echo "INTEL=$INTEL" >> /home/$CUR_USER/install-scripts/values.conf
echo "NVIDIA=$NVIDIA" >> /home/$CUR_USER/install-scripts/values.conf
echo "HYPRLAND=$HYPRLAND" >> /home/$CUR_USER/install-scripts/values.conf
echo "PLASMA=$PLASMA" >> /home/$CUR_USER/install-scripts/values.conf
