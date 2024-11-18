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
#sudo bash /home/$CUR_USER/arch-install/util/kernel/config-update.sh /etc/default/grub "GRUB_DISABLE_OS_PROBER=false"

sudo bash /home/$CUR_USER/arch-install/util/kernel/grub-add.sh usbcore.autosuspend=-1
sudo bash /home/$CUR_USER/arch-install/util/kernel/grub-add.sh pcie_aspm=off

if (( NVIDIA )); then
    sudo bash /home/$CUR_USER/arch-install/util/kernel/grub-add.sh nvidia_drm.modeset=1
    if (( INTEL )); then
        sudo bash /home/$CUR_USER/arch-install/util/kernel/grub-add.sh video=efifb:off
        echo "NO NEED TO DO WHATEVER THIS SCRIPT SAYS ^"
    else
        if (( HYPRLAND )); then
            sudo bash /home/$CUR_USER/arch-install/util/kernel/grub-add.sh nvidia.NVreg_PreserveVideoMemoryAllocations=1
            echo "NO NEED TO DO WHATEVER THIS SCRIPT SAYS ^"
        fi
    fi
else
    sudo bash /home/$CUR_USER/arch-install/util/kernel/grub-add.sh video=efifb:off
    echo "NO NEED TO DO WHATEVER THIS SCRIPT SAYS ^"
fi
sudo grub-mkconfig -o /boot/grub/grub.cfg

echo "Verify that the grub config /boot/grub/grub.cfg is correct."
echo "Reboot. After, verify success and run '~/arch-install/scripts/03-setup/01-packages-opt.sh'"
