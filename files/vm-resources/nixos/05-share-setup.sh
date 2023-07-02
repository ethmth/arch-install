#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi

CUR_USER=$(whoami)
sudo -k mkdir -p /sharepoint
mkdir -p /home/$CUR_USER/share
sudo mount -t 9p -o trans=virtio /sharepoint /home/$CUR_USER/share/

string_to_echo=$(echo "  fileSystems.\"/home/$CUR_USER/share\" = {
    device = \"/sharepoint\";
    fsType = \"9p\";
    options = [ \"trans=virtio\" ];
  };")

search_string="ADD_SHAREPOINT_SECTION_HERE"
file="/etc/nixos/configuration.nix"
tmp_file="/tmp/configuration.nix"

mv $file $tmp_file
touch $file

while IFS= read -r line; do
  echo "$line" >> "$file"
  if [[ $line == *"$search_string"* ]]; then
    echo "$string_to_echo" >> "$file"
  fi
done < "$tmp_file"

rm $file
mv "$tmp_file" "$file"

nixos-rebuild switch

echo "The ~/share directory should mount on boot now"
