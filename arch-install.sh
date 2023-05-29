#!/bin/bash

# Connect to internet
# pacman -S git
# git clone https://github.com/ethmth/install-scripts.git
# Run this script

# Install necessary packages
pacman -S vim fzf

# Font, Time
setfont ter-122b
timedatectl
read -p "Is the timedatectl correct (zone does not matter, just clock) (N for No, anything else for Yes)? " userInput

if ([ "$userInput" == "N" ] || [ "$userInput" == "n" ]); then
    echo "Alrighty then... fix it. Exiting now"
    exit 1
fi
clear

# Disk partititioning
disk=$(fdisk -l | grep "Disk /dev/" | grep -v "loop" | fzf --prompt="Select disk for BOOT and ROOT partitions" | awk -F'/' '{print $3}' | awk -F':' '{print $1}')
disk="/dev/$disk"
# to create the partitions programatically (rather than manually)
# we're going to simulate the manual input to fdisk
# The sed script strips off all the comments so that we can 
# document what we're doing in-line with the actual commands
# Note that a blank line (commented as "defualt" will send a empty
# line terminated with a newline to take the fdisk default.
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

read -p "Do these partitions look correct (N for No, anything else for Yes)? " userInput

if ([ "$userInput" == "N" ] || [ "$userInput" == "n" ]); then
    echo "Alrighty then... fix it. Exiting now"
    exit 1
fi
clear

# Disk formatting/encryption and mounting
mkfs.fat -F32 "${disk}1"
echo "ENCRYPTION SETUP FOR ROOT FILESYSTEM:"
cryptsetup luksFormat "${disk}2"
echo "Enter the password to unencrypt the disk:"
cryptsetup open "${disk}2" "rootfs"
mkfs.ext4 /dev/mapper/rootfs
mount /dev/mapper/rootfs /mnt
mount --mkdir "${disk}1" /mnt/boot
lsblk

read -p "Are the mountpoints correct (N for No, anything else for Yes)? " userInput

if ([ "$userInput" == "N" ] || [ "$userInput" == "n" ]); then
    echo "Alrighty then... fix it. Exiting now"
    exit 1
fi
clear


# ============ INSTALLATION =====================

pacstrap -K /mnt base base-devel linux linux-firmware networkmanager grub git vim nano cryptsetup lvm2 efibootmgr tmux curl wget fzf

read -p "Was the installation successful (N for No, anything else for Yes)? " userInput

if ([ "$userInput" == "N" ] || [ "$userInput" == "n" ]); then
    echo "Alrighty then... fix it. Exiting now"
    exit 1
fi
clear

echo "You will now be chrooted into the arch linux system."
echo "(If you're not, then run 'arch-chroot /mnt')"
echo "Run 'git clone https://github.com/ethmth/install-scripts.git /tmp/install-scripts'"
echo "Then '/tmp/install-scripts/arch-install-chroot.sh'"
arch-chroot /mnt