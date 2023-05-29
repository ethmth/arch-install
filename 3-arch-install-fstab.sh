#!/bin/bash

lsblk -f >> /mnt/etc/default/grub

genfstab -U /mnt >> /mnt/etc/fstab

echo "You will now be chrooted back into the arch linux system."
echo "(If you're not, then run 'arch-chroot /mnt')"
echo "Run 'git clone https://github.com/ethmth/install-scripts.git /tmp/install-scripts'"
echo "Then '/tmp/install-scripts/2-arch-install-chroot.sh'"
arch-chroot /mnt