#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi

CUR_USER=$(whoami)
source /home/$CUR_USER/arch-install/config/system.conf

if (( NVIDIA )); then
    sudo bash /home/$CUR_USER/arch-install/util/kernel/mkinit-edit.sh remove-hook "kms"
    sudo mkinitcpio -P
fi

echo "If using an Nvidia card, initcpio should have been regenerated without kms."
echo "Otherwise, no action was taken"
echo "Next, run ./10-grub.sh"
