#!/bin/bash

# Load Config Values
CUR_USER=$(whoami)
source /home/$CUR_USER/install-scripts/values.conf

# Clone and copy dot files
git clone https://github.com/ethmth/arch-dots.git /home/$CUR_USER/arch-dots
cp -r /home/$CUR_USER/arch-dots/home/* /home/$CUR_USER/

# Install openair vpn


# Install Magic Status Executables
if (( PLASMA )); then
    git clone https://github.com/ethmth/magic-status-executables.git /usr/share/plasma/plasmoids/com.github.ethmth.magic-status-executables
fi


