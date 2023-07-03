#!/bin/bash

SERVICE_NAME="weston"

if [[ $EUID -ne 0 ]]; then
	echo "This script must be run with root/sudo privileges."
	exit 1
fi

SCRIPT_PATH=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT_PATH")

if ! [ -f "$SCRIPT_DIR/$SERVICE_NAME.service" ]; then
    echo "$SCRIPT_DIR/$SERVICE_NAME.service not found"
    exit 1
fi

cp "$SCRIPT_DIR/$SERVICE_NAME.service" /etc/systemd/system/$SERVICE_NAME.service

string_to_echo=""
if [ "$SERVICE_NAME" == "weston" ]; then
string_to_echo=$(echo "  services.weston = {
  enable = true;
  wayland.enable = true;  # Enable Wayland protocol support
};")
fi

search_string="YOULL_NEVER_FIND_THIS_STRING"
if [ "$SERVICE_NAME" == "weston" ]; then
    search_string="ADD_WESTON_SERVICE_SECTION_HERE"
fi
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