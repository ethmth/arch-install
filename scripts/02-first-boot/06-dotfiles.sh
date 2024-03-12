#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi

CUR_USER=$(whoami)
source /home/$CUR_USER/arch-install/config/system.conf
source /home/$CUR_USER/arch-install/config/network-interface.conf

echo "Installing dotfiles..."
git clone https://github.com/ethmth/arch-dots.git /home/$CUR_USER/arch-dots
shopt -s dotglob

cp -r /home/$CUR_USER/arch-dots/home/* /home/$CUR_USER/
# TODO - change DEVICE variable in this hyprmon script depending on device:
sudo cp /home/$CUR_USER/.config/hypr/hyprmon.sh /usr/bin/hyprmon
sudo chmod +rx /usr/bin/hyprmon

sed -i "s/eth0/$NETWORK_INTERFACE/g" /home/$CUR_USER/.config/waybar/config.jsonc
rm -rf /home/$CUR_USER/arch-dots

echo "source ~/.config/bash/prompt" >> /home/$CUR_USER/.bashrc

echo "Verify that dotfiles were installed correctly"
echo "If so, run ./07-misc.sh"
