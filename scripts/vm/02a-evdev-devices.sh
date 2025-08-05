#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
        echo "This script should be run with root/sudo privileges."
        exit 1
fi

DEVICE_DIR="/dev/input/by-id"

DEVICES=$(ls -1 $DEVICE_DIR | fzf -m --prompt="Please select your devices")


XML_CONTENT="<devices>\n"
for device in $DEVICES; do
        XML_CONTENT+="\t<input type='evdev'>\n"
        XML_CONTENT+="\t\t<source dev='$DEVICE_DIR/$device'/>\n"
        XML_CONTENT+="\t</input>\n"
done
XML_CONTENT+="</devices>\n"

printf "$XML_CONTENT"