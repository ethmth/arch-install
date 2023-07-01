#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi

CUR_USER=$(whoami)
source /home/$CUR_USER/arch-install/config/system.conf
source /home/$CUR_USER/arch-install/config/network-interface.conf

# Install Magic Status Executables
if (( PLASMA )); then
	echo "Installing Plasma Widget - Magic Status Executables..."
    sudo -k git clone https://github.com/ethmth/magic-status-executables.git /usr/share/plasma/plasmoids/com.github.ethmth.magic-status-executables
fi

# Install spacemacs
echo "Installing spacemacs..."
git clone https://github.com/syl20bnr/spacemacs /home/$CUR_USER/.emacs.d

# Github Login
echo "Login to Github..."
git config --global credential.helper store
read -p "What is your Github username?: " git_user
read -p "What is your Github email?: " git_email
git config --global user.name "$git_user"
git config --global user.email "$git_email"

# Set Default Java Version for Arch Linux
sudo -k archlinux-java set java-17-openjdk

# SSH-keygen
sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | ssh-keygen
    # default dir 
    # no password
    # no password confirm
EOF

mkdir -p /home/$CUR_USER/Documents/Programs
mkdir -p /home/$CUR_USER/Pictures/Wallpapers
mkdir -p /home/$CUR_USER/Downloads

wget -O /home/$CUR_USER/Pictures/Wallpapers/wallpaper.png https://4kwallpapers.com/images/wallpapers/windows-11-purple-abstract-dark-background-dark-purple-dark-3840x2400-8995.png

# source pyenv
echo 'eval "$(pyenv init -)"' >> /home/$CUR_USER/.bashrc

# npm user setup
echo "export npm_config_prefix=\"\$HOME/.local\"" >> /home/$CUR_USER/.bashrc

echo "Verify that installation of various misc software was successful"
echo "If so, run ./08-scripts.sh"
