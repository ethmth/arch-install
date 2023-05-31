#!/bin/bash

# Load Config Values
CUR_USER=$(whoami)
source /home/$CUR_USER/install-scripts/values.conf

if ! [[ $EUID -ne 0 ]]; then
	echo "Do not run this script as sudo/root."
	exit 1
fi

# Clone and copy dot files
git clone https://github.com/ethmth/arch-dots.git /home/$CUR_USER/arch-dots
shopt -s dotglob
cp -r /home/$CUR_USER/arch-dots/home/* /home/$CUR_USER/
rm -rf /home/$CUR_USER/arch-dots

# Source bash prompt
echo "source ~/.config/bash/prompt" >> /home/$CUR_USER/.bashrc

# Install Magic Status Executables
if (( PLASMA )); then
    sudo -k git clone https://github.com/ethmth/magic-status-executables.git /usr/share/plasma/plasmoids/com.github.ethmth.magic-status-executables
fi

# Install spacemacs