#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script must NOT be run with root/sudo privileges."
	exit 1
fi

# Load Config Values
CUR_USER=$(whoami)
source /home/$CUR_USER/install-scripts/values.conf
#source ../values.conf.example

current_arguments=$(grep "^GRUB_CMDLINE_LINUX_DEFAULT" /etc/default/grub | sed 's/GRUB_CMDLINE_LINUX_DEFAULT=//' | tr -d '"')

new_arguments=""

if (( INTEL_CPU )); then
    new_arguments+="intel_iommu=on "
fi
new_arguments+="iommu=pt"

#echo "$new_arguments $current_arguments"
sudo -k sed -i "s/^\(GRUB_CMDLINE_LINUX_DEFAULT=\).*/\1\"$new_arguments $current_arguments\"/" /etc/default/grub
