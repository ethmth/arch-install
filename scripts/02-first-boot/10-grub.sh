#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi

CUR_USER=$(whoami)
source /home/$CUR_USER/arch-install/config/system.conf

sudo -k bash /home/$CUR_USER/arch-install/util/kernel/config-update.sh /etc/default/grub "GRUB_SAVEDEFAULT=true"
sudo bash /home/$CUR_USER/arch-install/util/kernel/config-update.sh /etc/default/grub "GRUB_DISABLE_SUBMENU=y"
sudo bash /home/$CUR_USER/arch-install/util/kernel/config-update.sh /etc/default/grub "GRUB_DEFAULT=saved"
sudo bash /home/$CUR_USER/arch-install/util/kernel/config-update.sh /etc/default/grub "GRUB_TIMEOUT=3"
if (( NVIDIA )); then
    sudo bash /home/$CUR_USER/arch-install/util/kernel/grub-add.sh ibt=off nvidia_drm.modeset=1 usbcore.autosuspend=-1 video=efifb:off
    echo "NO NEED TO DO WHATEVER THIS SCRIPT SAYS ^"
else
    sudo bash /home/$CUR_USER/arch-install/util/kernel/grub-add.sh usbcore.autosuspend=-1 video=efifb:off
    echo "NO NEED TO DO WHATEVER THIS SCRIPT SAYS ^"
fi
sudo grub-mkconfig -o /boot/grub/grub.cfg

echo "Verify that the grub config /boot/grub/grub.cfg is correct."
echo "Reboot. After, verify success and run '~/arch-install/scripts/03-setup/01-packages-opt.sh'"
