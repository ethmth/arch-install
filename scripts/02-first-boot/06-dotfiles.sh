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

echo "Verify that dotfiles were installed correctly"
echo "If so, run ./07-misc.sh"
