#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi

CUR_USER=$(whoami)
source /home/$CUR_USER/arch-install/config/system.conf

if (( INTEL )); then
    sudo bash /home/$CUR_USER/arch-install/util/kernel/mkinit-edit.sh add-modules -b end i915
fi

if (( AMD )); then
    sudo bash /home/$CUR_USER/arch-install/util/kernel/mkinit-edit.sh add-modules -b end amdgpu
fi

if (( NVIDIA )); then
    sudo bash /home/$CUR_USER/arch-install/util/kernel/mkinit-edit.sh add-modules -b end nvidia nvidia_modeset nvidia_uvm nvidia_drm

    sudo mkdir -p /etc/pacman.d/hooks
    sudo cp /home/$CUR_USER/arch-install/files/configs/nvidia.hook /etc/pacman.d/hooks/nvidia.hook
fi
# sudo bash /home/$CUR_USER/arch-install/util/kernel/mkinit-edit.sh remove-hook kms

sudo mkinitcpio -P

echo "Initcpio should have been regenerated without kms and with the appropriate video driver in MODULES."
echo "Otherwise, no action was taken"
echo "Next, run ./10-grub.sh"
