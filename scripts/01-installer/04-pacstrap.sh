#!/bin/bash

# ============ INSTALLATION =====================

pacstrap -K /mnt base base-devel linux linux-firmware networkmanager grub git vim vi nano cryptsetup lvm2 efibootmgr dosfstools os-prober mtools tmux curl wget fzf

echo "Verify that the package installation was successful."
echo "If so, run ./05-disk-grub.sh"
