#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi

CUR_USER=$(whoami)
source /home/$CUR_USER/arch-install/config/system.conf


read -p "Do you need the ACS Override patch (y/N)? " userInput

if ! ([ "$userInput" == "Y" ] || [ "$userInput" == "y" ]); then
    echo "ACS Patch not selected, no action taken"
    exit 0
fi

sudo bash /home/$CUR_USER/arch-install/util/kernel/grub-add.sh pcie_acs_override=downstream,multifunction
echo "NO NEED TO DO WHATEVER THIS SCRIPT SAYS ^"

sudo grub-mkconfig -o /boot/grub/grub.cfg

echo "Verify that the grub config /etc/default/grub is correct."
echo "Reboot. After, run '~/arch-install/util/vm/iommu_groups.sh' to view iommu groups"
echo "If you can see proper iommu groups, run ./04-bind-vfio.sh"
