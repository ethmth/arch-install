
lsblk

cryptsetup open /dev/sda2 cryptlvm

mount /dev/mapper/cryptlvm /mnt

mount /dev/sda1 /mnt/boot

arch-chroot /mnt

