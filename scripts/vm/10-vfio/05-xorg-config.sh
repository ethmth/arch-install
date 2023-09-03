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

selected_line=$(printf "$string" | grep "VGA" | fzf --prompt="Please select the gpu you want the host to use")

if [ "$selected_line" == "" ]; then
	echo "Nothing selected"
	exit 1
fi

IS_NVIDIA=$(echo "$selected_line" | grep "NVIDIA" | wc -l)

gpu_pci_group=$(echo "$selected_line" | cut -d ' ' -f 2)
gpu_pci_id=$(echo "$selected_line" | grep -o '\[[[:alnum:]]\{4\}:[[:alnum:]]\{4\}\]')
groups="0000:$gpu_pci_group"

ids=""
gpu_pci_id="${gpu_pci_id//\[}"
gpu_pci_id="${gpu_pci_id//\]}"

if ! (( IS_NVIDIA )); then
    echo "Not an Nvidia GPU. Doing nothing."
    exit 1
fi

bus_id=$gpu_pci_group
IFS=":" read -r -a bus_id_parts <<< "$bus_id"

bus_id="PCI:${bus_id_parts[0]#0}:${bus_id_parts[1]#0}${bus_id_parts[2]#0}"
echo "Adding $bus_id to xorg config"

sudo sh -c "echo \"Section \\\"Device\\\"
    Identifier \\\"Device0\\\"
    Driver \\\"nvidia\\\"
    VendorName \\\"NVIDIA Corporation\\\"
    BusID \\\"$bus_id\\\"
EndSection\" > /etc/X11/xorg.conf.d/10-nvidia.conf"
