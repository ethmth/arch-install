#!/bin/bash

# Load Config Values
CUR_USER=$(whoami)
source /home/$CUR_USER/install-scripts/values.conf


# Update grub with new config and kernels
sudo sh -c 'echo "GRUB_SAVEDEFAULT=true" >> /etc/default/grub'
sudo sh -c 'echo "GRUB_DISABLE_SUBMENU=y" >> /etc/default/grub'
sudo sed -i 's/GRUB_DEFAULT=0/#&\nGRUB_DEFAULT=saved/' /etc/default/grub
sudo sed -i 's/GRUB_TIMEOUT=5/#&\nGRUB_TIMEOUT=3/' /etc/default/grub
if (( NVIDIA )); then
    current_arguments=$(grep "^GRUB_CMDLINE_LINUX_DEFAULT" /etc/default/grub | sed 's/GRUB_CMDLINE_LINUX_DEFAULT=//' | tr -d '"')
    sudo sed -i "s/^\(GRUB_CMDLINE_LINUX_DEFAULT=\).*/\1\"ibt=off $current_arguments\"/" /etc/default/grub
fi
sudo grub-mkconfig -o /boot/grub/grub.cfg
