#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi

CUR_USER=$(whoami)
source /home/$CUR_USER/arch-install/config/system.conf

string=""
shopt -s nullglob
for g in $(find /sys/kernel/iommu_groups/* -maxdepth 0 -type d | sort -V); do
    for d in $g/devices/*; do
		number=${g##*/}
        string+="iommu_grp_"
		string+=$(printf "%02d" "$number")
        string+=": "
        string+="$(lspci -nns ${d##*/})\n"
    done;
done;

pci_ids=$(printf "$string" | fzf -m | grep -o '\[[[:alnum:]]\{4\}:[[:alnum:]]\{4\}\]')

ids=""
while IFS= read -r line; do
	temp_line=$line
	temp_line="${temp_line//\[}"
	temp_line="${temp_line//\]}"
	ids+="$temp_line,"
done <<< "$pci_ids"
ids="${ids%?}"

echo "Adding these ids to blocklist: $ids"

sudo -k sh -c "echo \"options vfio-pci ids=$ids\" > /etc/modprobe.d/vfio.conf"
#sudo sh -c "echo \"softdep drm pre: vfio-pci\" >> /etc/modprobe.d/vfio.conf"
sudo bash /home/$CUR_USER/arch-install/util/kernel/mkinit-edit.sh add-modules -a "start" vfio_pci vfio vfio_iommu_type1
echo "NO NEED TO DO WHAT THIS SCRIPT SAYS ^"
sudo mkinitcpio -P

echo "Reboot and verify that the vfio drivers are loaded on your intended device(s) by running 'dmesg | grep -i vfio'"
echo "To view the specific drivers on a pci device run 'lspci -nnk -d 10de:13c2', using the appropriate id."
# echo "After you're done, begin setting up the virtual networks by running ./03-network-default.sh"
