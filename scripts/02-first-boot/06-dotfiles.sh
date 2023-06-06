#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi

CUR_USER=$(whoami)
source /home/$CUR_USER/arch-install/config/system.conf

# Clone and copy dot files
echo "Installing dotfiles..."
git clone https://github.com/ethmth/arch-dots.git /home/$CUR_USER/arch-dots
shopt -s dotglob
cp -r /home/$CUR_USER/arch-dots/home/* /home/$CUR_USER/
rm -rf /home/$CUR_USER/arch-dots
# TODO - change DEVICE variable in this hyprmon script depending on device:
sudo -k cp /home/$CUR_USER/arch-dots/home/.config/hypr/hyprmon.sh /usr/bin/hyprmon
sudo chmod +x /usr/bin/hyprmon

# Source bash prompt
echo "source ~/.config/bash/prompt" >> /home/$CUR_USER/.bashrc

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

mkdir -p /home/$CUR_USER/Documents/Programs

echo "Verify that dotfiles were installed correctly"
echo "If so, run ./07-scripts.sh"
