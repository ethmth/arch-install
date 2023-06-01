#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi

CUR_USER=$(whoami)
source /home/$CUR_USER/arch-install/config/system.conf

# sudo sh -c 'echo "GRUB_SAVEDEFAULT=true" >> /etc/default/grub'
sudo -k bash /home/$CUR_USER/arch-install/util/kernel/config-update.sh /etc/default/grub "GRUB_SAVEDEFAULT=true"
# sudo sh -c 'echo "GRUB_DISABLE_SUBMENU=y" >> /etc/default/grub'
sudo bash /home/$CUR_USER/arch-install/util/kernel/config-update.sh /etc/default/grub "GRUB_DISABLE_SUBMENU=y"
# sudo sed -i 's/GRUB_DEFAULT=0/#&\nGRUB_DEFAULT=saved/' /etc/default/grub
sudo bash /home/$CUR_USER/arch-install/util/kernel/config-update.sh /etc/default/grub "GRUB_DEFAULT=saved"
# sudo sed -i 's/GRUB_TIMEOUT=5/#&\nGRUB_TIMEOUT=3/' /etc/default/grub
sudo bash /home/$CUR_USER/arch-install/util/kernel/config-update.sh /etc/default/grub "GRUB_TIMEOUT=3"
if (( NVIDIA )); then
    # current_arguments=$(grep "^GRUB_CMDLINE_LINUX_DEFAULT" /etc/default/grub | sed 's/GRUB_CMDLINE_LINUX_DEFAULT=//' | tr -d '"')
    # sudo sed -i "s/^\(GRUB_CMDLINE_LINUX_DEFAULT=\).*/\1\"ibt=off $current_arguments\"/" /etc/default/grub
    sudo bash /home/$CUR_USER/arch-install/util/kernel/grub-add.sh "ibt=off"
    echo "NO NEED TO DO WHATEVER THIS SCRIPT SAYS ^"
fi
sudo grub-mkconfig -o /boot/grub/grub.cfg

echo "Verify that the grub config /etc/default/grub is correct."
echo "Reboot. After, verify success and run '~/arch-install/scripts/03-setup/01-packages-opt.sh'"