#!/bin/bash

tz_dir=$(ls /usr/share/zoneinfo | fzf --prompt="Select timezone directory")
tz_zone=$(ls /usr/share/zoneinfo/$tz_dir | fzf --prompt="Select timezone")
ln -s /usr/share/zoneinfo/$tz_dir/$tz_zone /etc/localtime
ls -l /etc/localtime

read -p "Is there a link to the correct timezone in /etc/localtime (N for No, otherwise Yes)? " userInput

if ([ "$userInput" == "N" ] || [ "$userInput" == "n" ]); then
    echo "Manual intervention needed. Exiting script now."
    exit 1
fi
clear