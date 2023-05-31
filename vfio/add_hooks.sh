#!/bin/bash

if [[ $EUID -ne 0 ]]; then
	echo "This script must be run with root/sudo privileges."
	exit 1
fi

#conf_file="/etc/mkinitcpio.conf"
conf_file="mkinitcpio.conf"

hooks=("$@")  # Add the hooks you want to check and add here
read -p "Please input your desired name for the disk: " after


# Check if the hooks are already present in the file
for hook in "${hooks[@]}"; do
    if grep -q "^HOOKS=.*$hook" "$conf_file"; then
        echo "The hook $hook is already present in $conf_file."
    else
        echo "Adding the hook $hook to $conf_file."
        sed -i "/^HOOKS=/ s/\(^\(HOOKS=.*\)\)\$/\1 $hook/" "$conf_file"
    fi
done
