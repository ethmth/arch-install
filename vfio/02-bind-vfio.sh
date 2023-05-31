#!/bin/bash

string=""
shopt -s nullglob
for g in $(find /sys/kernel/iommu_groups/* -maxdepth 0 -type d | sort -V); do
    for d in $g/devices/*; do
        #printf "IOMMU Group ${g##*/}: "
        string+="IOMMU Group ${g##*/}: "
        #echo -e "\t$(lspci -nns ${d##*/})"
        string+="\t$(lspci -nns ${d##*/})"
    done;
done;

pci_ids=$(echo "$string" | fzf -m)