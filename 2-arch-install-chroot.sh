#!/bin/bash

# TimeZone Setup
tz_dir=$(ls /usr/share/zoneinfo | fzf --prompt="Select timezone directory")
tz_zone=$(ls /usr/share/zoneinfo/$tz_dir | fzf --prompt="Select timezone")
ln -s /usr/share/zoneinfo/$tz_dir/$tz_zone /etc/localtime
ls -l /etc/localtime

read -p "Is there a link to the correct timezone in /etc/localtime (N for No, otherwise Yes)? " userInput

if ([ "$userInput" == "N" ] || [ "$userInput" == "n" ]); then
    echo "Manual intervention needed. Exiting script now."
    exit 1
fi
clear

hwclock --systohc

# Locale Gen
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

# Hostname
read -p "Please input your desired hostname: " hostname
read -p "Is '$hostname' your desired hostname (N for No, otherwise Yes)? " userInput

while ([ "$userInput" == "N" ] || [ "$userInput" == "n" ]); do
    read -p "Please input your desired hostname: " hostname
    read -p "Is '$hostname' your desired hostname (N for No, otherwise Yes)? " userInput
done
echo "Hostname: $hostname"
echo "$hostname" > /etc/hostname

# Network Configuration
echo "" >> /etc/hosts
echo "127.0.0.1     localhost" >> /etc/hosts
echo "::1           localhost" >> /etc/hosts
echo "127.0.1.1     $hostname.localdomain $hostname" >> /etc/hosts

echo "Contents of /etc/hostname:"
cat /etc/hostname
echo "Contents of /etc/hosts:"
cat /etc/hosts


read -p "Is this information correct (N for No, otherwise Yes)? " userInput

if ([ "$userInput" == "N" ] || [ "$userInput" == "n" ]); then
    echo "Manual intervention needed. Exiting script now."
    exit 1
fi
clear

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
sed -i '/^HOOKS/s/block/block encrypt lvm2/' /etc/mkinitcpio.conf
sed -i '/^HOOKS/s/keyboard //' /etc/mkinitcpio.conf
sed -i '/^HOOKS/s/autodetect/keyboard autodetect/' /etc/mkinitcpio.conf
# sed -i '/^HOOKS/s/filesystems/filesystems resume/' /etc/mkinitcpio.conf
mkinitcpio -P

# Grub Command Line Arguments
grub_string=$(cat /opt/grub_string.txt)
rm /opt/grub_string.txt
current_arguments=$(grep "^GRUB_CMDLINE_LINUX_DEFAULT" /etc/default/grub | sed 's/GRUB_CMDLINE_LINUX_DEFAULT=//' | tr -d '"')
sed -i "s/^\(GRUB_CMDLINE_LINUX_DEFAULT=\).*/\1\"$current_arguments $grub_string\"/" /etc/default/grub
sed -i 's/ quiet//g' /etc/default/grub

#echo "GRUB_ENABLE_CRYPTODISK=y" >> /etc/default/grub

# Grub Installation
grub-install --target=x86_64-efi --bootloader-id=grub_uefi --recheck --removable
# grub-install --target=x86_64-efi --bootloader-id=grub_uefi --efi-directory=/boot --recheck --removable
# grub-install --target=x86_64-efi --bootloader-id=grub_uefi --recheck --removable
grub-mkconfig -o /boot/grub/grub.cfg

echo "You will now un-chroot yourself back into the arch linux installer."
echo "Type 'exit'"
echo "Then shutdown ('shutdown now') (in the arch linux installer), take out installation medium, and boot back up"