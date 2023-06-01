#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi

CUR_USER=$(whoami)
source /home/$CUR_USER/arch-install/config/system.conf

# current_arguments=$(grep "^GRUB_CMDLINE_LINUX_DEFAULT" /etc/default/grub | sed 's/GRUB_CMDLINE_LINUX_DEFAULT=//' | tr -d '"')

# new_arguments=""

if (( INTEL_CPU )); then
    # new_arguments+="intel_iommu=on "
	sudo bash /home/$CUR_USER/arch-install/util/kernel/grub-add.sh intel_iommu=on iommu=pt
    echo "NO NEED TO DO WHATEVER THIS SCRIPT SAYS ^"
else 
	sudo bash /home/$CUR_USER/arch-install/util/kernel/grub-add.sh iommu=pt
	echo "NO NEED TO DO WHATEVER THIS SCRIPT SAYS ^"
fi
# new_arguments+="iommu=pt"

# sudo -k sed -i "s/^\(GRUB_CMDLINE_LINUX_DEFAULT=\).*/\1\"$new_arguments $current_arguments\"/" /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg

echo "Verify that the grub config /etc/default/grub is correct."
echo "Reboot. After, run '~/arch-install/util/vm/iommu_groups.sh' to view iommu groups"
echo "If you can see iommu groups, run ./02-bind-vfio.sh"