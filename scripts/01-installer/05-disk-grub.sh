#!/bin/bash

# Disk things
uuid_crypt=$(lsblk -f | grep crypto_LUKS | awk '{print $4}')
grub_string="cryptdevice=UUID=$uuid_crypt:cryptlvm:allow-discards"
echo "$grub_string" > /mnt/opt/grub_string.txt
genfstab -U /mnt >> /mnt/etc/fstab

echo "You will now be chrooted into the arch linux system."
echo "(If you're not, then run 'arch-chroot /mnt')"
echo "Run 'git clone https://github.com/ethmth/arch-install.git /tmp/arch-install'"
echo "Then '/tmp/arch-install/scripts/01-installer/11-timezone.sh'"
arch-chroot /mnt bash
