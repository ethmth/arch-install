#!/bin/bash

if [[ $EUID -ne 0 ]]; then
	echo "This script should be run with root/sudo privileges."
	exit 1
fi

mkdir -p /sharepoint
mkdir -p /mnt/share
mount -t 9p -o trans=virtio /sharepoint /mnt/share/

chmod -R 777 /mnt/share

string_to_echo=$(echo "  fileSystems.\"/mnt/share\" = {
    device = \"/sharepoint\";
    fsType = \"9p\";
    options = [ \"trans=virtio\" ];
  };")

search_string="ADD_SHAREPOINT_SECTION_HERE"
file="/etc/nixos/configuration.nix"
tmp_file="/tmp/configuration.nix"

cp $file $tmp_file
printf "" > $file

while IFS= read -r line; do
  echo "$line" >> "$file"
  if [[ $line == *"$search_string"* ]]; then
    echo "$string_to_echo" >> "$file"
  fi
done < "$tmp_file"

rm $tmp_file

nixos-rebuild switch

echo "The ~/share directory should mount on boot now"
