#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi

# Install yay
cd
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --needed --noconfirm
cd
rm -rf yay

echo "Verify that the installation of yay was successful"
echo "ENABLE THE MULTILIB REPO BY UNCOMMENTING LINES IN /etc/pacman.conf"
echo "If so, run ./03-packages.sh"
