#!/bin/bash

# Connect to internet
# pacman -S git
# git clone https://github.com/ethmth/install-scripts.git
# Run this script

pacman -S vim fzf

setfont ter-122b
timedatectl

disk=$(fdisk -l | grep "Disk /dev/" | grep -v "loop" | fzf | awk -F'/' '{print $3}' | awk -F':' '{print $1}')
disk="/dev/$disk"
