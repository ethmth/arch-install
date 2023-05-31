#!/bin/bash

string=""
shopt -s nullglob
for g in $(find /sys/kernel/iommu_groups/* -maxdepth 0 -type d | sort -V); do
    for d in $g/devices/*; do
        #printf "IOMMU Group ${g##*/}: "
		number=${g##*/}
        string+="iommu_grp_"
		string+=$(printf "%02d" "$number")
        string+=": "
        #echo -e "\t$(lspci -nns ${d##*/})"
        string+="$(lspci -nns ${d##*/})\n"
    done;
done;

#pci_ids=$(printf "$string" | fzf -m | awk '{print $2}')
#pci_ids=$(printf "$string" | fzf -m | awk '{ if(NF >= 3) { print $(NF-2) } }')
pci_ids=$(printf "$string" | fzf -m | grep -o '\[[[:alnum:]]\{4\}:[[:alnum:]]\{4\}\]')
#echo "$pci_ids"

ids=""
while IFS= read -r line; do
	#ids+="$line,"
	temp_line=$line
	temp_line="${temp_line//\[}"
	temp_line="${temp_line//\]}"
	ids+="$temp_line,"
done <<< "$pci_ids"
ids="${ids%?}"

sudo -k sh -c "echo \"options vfio-pci ids=$ids\" > /etc/modprobe.d/vfio.conf"
sudo sh -c "echo \"softdep drm pre: vfio-pci\" >> /etc/modprobe.d/vfio.conf"
sudo mkinitcpio -P
