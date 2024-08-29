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

if (( LAPTOP )); then
bash /home/$CUR_USER/arch-install/util/kernel/config-update.sh /home/$CUR_USER/.config/hypr/hyprmon.sh 'DEVICE="laptop"'
elif (( DESKTOP )); then
bash /home/$CUR_USER/arch-install/util/kernel/config-update.sh /home/$CUR_USER/.config/hypr/hyprmon.sh 'DEVICE="desktop"'
fi

sudo cp /home/$CUR_USER/.config/hypr/hyprmon.sh /usr/local/bin/hyprmon
sudo chmod +rx /usr/local/bin/hyprmon

sed -i "s/eth0/$NETWORK_INTERFACE/g" /home/$CUR_USER/.config/waybar/config.jsonc
rm -rf /home/$CUR_USER/arch-dots

if ! ( cat "/home/$CUR_USER/.bashrc" | grep "source ~/.config/bash/prompt" ); then
	echo "source ~/.config/bash/prompt" >> /home/$CUR_USER/.bashrc
fi

echo "Verify that dotfiles were installed correctly"
echo "If so, run ./07-misc.sh"
