#!/bin/bash

# Install necessary packages
pacman -S vim fzf

# Font, Time
setfont ter-122b
timedatectl
read -p "Is the timedatectl correct (zone does not matter, just clock) (N for No, otherwise Yes)? " userInput

if ([ "$userInput" == "N" ] || [ "$userInput" == "n" ]); then
    echo "Manual intervention needed. Exiting script now."
    exit 1
fi
clear

# Disk partititioning
disk=$(fdisk -l | grep "Disk /dev/" | grep -v "loop" | fzf --prompt="Select disk for BOOT and ROOT partitions" | awk -F'/' '{print $3}' | awk -F':' '{print $1}')
disk="/dev/$disk"
sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk ${disk}
  g # clear the in memory partition table
  n # new partition
  p # primary partition
  1 # partition number 1
    # default - start at beginning of disk 
  +1G # 1 GB boot parttion
  n # new partition
  p # primary partition
  2 # partion number 2
    # default, start immediately after preceding partition
    # default, extend partition to end of disk
  w # write the partition table
EOF
echo "Partitions created:"
fdisk -l | grep "$disk"

read -p "Do these partitions look correct (N for No, otherwise Yes)? " userInput

if ([ "$userInput" == "N" ] || [ "$userInput" == "n" ]); then
    echo "Manual intervention needed. Exiting script now."
    exit 1
fi
clear

# Disk formatting/encryption and mounting
mkfs.fat -F32 "${disk}1"
echo "Encryption setup for root filesystem:"
cryptsetup luksFormat "${disk}2"
echo "Enter the password to unencrypt the disk:"
cryptsetup open "${disk}2" "rootfs"
mkfs.ext4 /dev/mapper/rootfs
mount /dev/mapper/rootfs /mnt
mount --mkdir "${disk}1" /mnt/boot
lsblk

read -p "Are the mountpoints correct (N for No, otherwise Yes)? " userInput

if ([ "$userInput" == "N" ] || [ "$userInput" == "n" ]); then
    echo "Manual intervention needed. Exiting script now."
    exit 1
fi
clear


# ============ INSTALLATION =====================

pacstrap -K /mnt base base-devel linux linux-firmware networkmanager grub git vim nano cryptsetup lvm2 efibootmgr tmux curl wget fzf

read -p "Were the package installations successful (N for No, otherwise Yes)? " userInput

if ([ "$userInput" == "N" ] || [ "$userInput" == "n" ]); then
    echo "Manual intervention needed. Exiting script now."
    exit 1
fi
clear

# Disk things
lsblk -f >> /mnt/tmp/lsblk.out
genfstab -U /mnt >> /mnt/etc/fstab

echo "You will now be chrooted into the arch linux system."
echo "(If you're not, then run 'arch-chroot /mnt')"
echo "Run 'git clone https://github.com/ethmth/install-scripts.git /tmp/install-scripts'"
echo "Then '/tmp/install-scripts/2-arch-install-chroot.sh'"
arch-chroot /mnt