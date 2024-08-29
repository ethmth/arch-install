#!/bin/bash

# Enabling NetworkManager
systemctl enable NetworkManager.service

# Setting root password
echo "Please enter the desired root password:"
passwd

# Add a user
read -p "Please input your desired username: " username
read -p "Is '$username' your desired username (N for No, otherwise Yes)? " userInput

while ([ "$userInput" == "N" ] || [ "$userInput" == "n" ]); do
    read -p "Please input your desired username: " username
    read -p "Is '$username' your desired username (N for No, otherwise Yes)? " userInput
done
echo "Username: $username"

useradd -G wheel -m $username
echo "Please set the password for $username:"
passwd $username

echo "%wheel ALL=(ALL:ALL) ALL" > /etc/sudoers.d/wheel-group
usermod -aG audio,video,optical,storage $username

# Grub configuration
bash /tmp/arch-install/util/kernel/mkinit-edit.sh add-hooks -a block encrypt lvm2
echo "NO NEED TO DO WHATEVER THIS SCRIPT SAYS ^"
bash /tmp/arch-install/util/kernel/mkinit-edit.sh add-hooks -b autodetect keyboard
echo "NO NEED TO DO WHATEVER THIS SCRIPT SAYS ^"
mkinitcpio -P

# Grub Command Line Arguments
grub_string=$(cat /opt/grub_string.txt)
rm /opt/grub_string.txt
sed -i 's/ quiet//g' /etc/default/grub
bash /tmp/arch-install/util/kernel/grub-add.sh "$grub_string"
echo "NO NEED TO DO WHATEVER THIS SCRIPT SAYS ^"

# Grub Installation
grub-install --target=x86_64-efi --bootloader-id=grub_uefi --efi-directory=/boot --recheck --removable
grub-mkconfig -o /boot/grub/grub.cfg

echo "You will now un-chroot yourself back into the arch linux installer."
echo "Type 'exit'"
echo "Then shutdown ('shutdown now') (in the arch linux installer), take out installation medium, boot back up, and connect to the internet"
echo "Then, login and run 'git clone https://github.com/ethmth/arch-install.git' in ~/ and execute '~/arch-install/scripts/02-first-boot/01-config.sh'"
