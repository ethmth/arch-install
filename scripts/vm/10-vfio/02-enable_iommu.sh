#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi

CUR_USER=$(whoami)
source /home/$CUR_USER/arch-install/config/system.conf

if (( INTEL_CPU )); then
	sudo bash /home/$CUR_USER/arch-install/util/kernel/grub-add.sh intel_iommu=on iommu=pt
    echo "NO NEED TO DO WHATEVER THIS SCRIPT SAYS ^"
else 
	sudo bash /home/$CUR_USER/arch-install/util/kernel/grub-add.sh iommu=pt
	echo "NO NEED TO DO WHATEVER THIS SCRIPT SAYS ^"
fi

sudo grub-mkconfig -o /boot/grub/grub.cfg

echo "Verify that the grub config /etc/default/grub is correct."
echo "Reboot. After, run '~/arch-install/util/vm/iommu_groups.sh' to view iommu groups"
echo "If you can see iommu groups, run ./04-bind-vfio.sh. If you need the ACS override, run ./03-acs-patch.sh"
