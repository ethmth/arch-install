#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi

if ! [ -f "./custom-vfio-hook.sh" ]; then
    echo "Make sure you run this in the correct directory"
    exit 1
fi

if ! [ -d "./custom-vfio-hook-files" ]; then
    echo "Make sure you run this in the correct directory"
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

selected_line=$(printf "$string" | grep "VGA" | fzf --prompt="Please select your gpu")

if [ "$selected_line" == "" ]; then
	echo "Nothing selected"
	exit 1
fi

AMD_GPU=$(echo "$selected_line" | grep "AMD" | wc -l)

gpu_pci_group=$(echo "$selected_line" | cut -d ' ' -f 2)
gpu_pci_id=$(echo "$selected_line" | grep -o '\[[[:alnum:]]\{4\}:[[:alnum:]]\{4\}\]')
groups="0000:$gpu_pci_group"

ids=""
gpu_pci_id="${gpu_pci_id//\[}"
gpu_pci_id="${gpu_pci_id//\]}"
ids+="$gpu_pci_id,"

pci_ids=$(printf "$string" | grep -v "$gpu_pci_id" | fzf -m --prompt="Please select your other devices")

if [ "$pci_ids" == "" ]; then
	echo "Nothing selected"
	exit 1
fi

while IFS= read -r line; do
	temp_group=$(echo "$line" | cut -d ' ' -f 2)
	temp_line=$(echo "$line" | grep -o '\[[[:alnum:]]\{4\}:[[:alnum:]]\{4\}\]')
	temp_line="${temp_line//\[}"
	temp_line="${temp_line//\]}"
	ids+="$temp_line,"
	groups+=" 0000:$temp_group"
done <<< "$pci_ids"
ids="${ids%?}"

gpu_pci_group_with_underscores=$(echo "$gpu_pci_group" | tr '.:' '_')

echo "Adding these ids to blocklist: $ids (groups: $groups)"

if (( AMD_GPU )); then
# sudo sh -c "echo \"#!/bin/bash\" > /usr/bin/gpustart"
# sudo sh -c "echo \"echo \"\'0000:$gpu_pci_group\'\" | sudo tee /sys/bus/pci/drivers/vfio-pci/unbind /sys/bus/pci/drivers/amdgpu/bind\" >> /usr/bin/gpustart"
# sudo sh -c "echo \"echo \"\"'DRI_PRIME=1 glxinfo | grep \"\'OpenGL\'\" | grep \"\'renderer\'\"'\"\"\" >> /usr/bin/gpustart"
# sudo chmod +rx /usr/bin/gpustart

sudo sh -c 'echo "#!/bin/bash" > /usr/local/bin/gpustart'
sudo sh -c 'echo "echo \"Edit this script (/usr/local/bin/gpustart) and keep whichever method works\"" > /usr/local/bin/gpustart'
sudo sh -c "echo \"#sudo virsh nodedev-reattach pci_0000_$gpu_pci_group_with_underscores\" >> /usr/local/bin/gpustart"
sudo sh -c "echo \"#echo \"\'0000:$gpu_pci_group\'\" | sudo tee /sys/bus/pci/drivers/vfio-pci/unbind /sys/bus/pci/drivers/amdgpu/bind\" >> /usr/local/bin/gpustart"
sudo chmod +rx /usr/local/bin/gpustart

# sudo sh -c "echo \"#!/bin/bash\" > /usr/bin/gpustop"
# sudo sh -c "echo \"sudo virsh nodedev-detach pci_0000_$gpu_pci_group_with_underscores\" >> /usr/bin/gpustop"
# sudo chmod +rx /usr/bin/gpustop

sudo sh -c "echo \"#!/bin/bash\" > /usr/local/bin/gpucheck"
sudo sh -c "echo \"DRI_PRIME=1 glxinfo | grep \"\'OpenGL\'\" | grep \"\'renderer\'\"\" >> /usr/local/bin/gpucheck"
sudo sh -c "echo \"lspci -nnk -d $gpu_pci_id | grep Kernel\" >> /usr/local/bin/gpucheck"
sudo chmod +rx /usr/local/bin/gpucheck
fi

if (( NVIDIA && ! INTEL )); then
sudo bash ./custom-vfio-hook.sh IUNDERSTAND $CUR_USER "$groups"
else
sudo sh -c "echo \"options vfio-pci ids=$ids\" > /etc/modprobe.d/vfio.conf"
sudo bash /home/$CUR_USER/arch-install/util/kernel/mkinit-edit.sh add-modules -b "end" vfio_pci vfio vfio_iommu_type1
echo "NO NEED TO DO WHAT THIS SCRIPT SAYS ^"
fi

sudo mkinitcpio -P

echo "Reboot and verify that the vfio drivers are loaded on your intended device(s) by running 'dmesg | grep -i vfio'"
echo "To view the specific drivers on a pci device run 'lspci -nnk -d 10de:13c2', using the appropriate id."
