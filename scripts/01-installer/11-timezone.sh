#!/bin/bash

# TimeZone Setup
tz_dir=$(ls /usr/share/zoneinfo | fzf --prompt="Select timezone directory")
tz_zone=$(ls /usr/share/zoneinfo/$tz_dir | fzf --prompt="Select timezone")
ln -s /usr/share/zoneinfo/$tz_dir/$tz_zone /etc/localtime
ls -l /etc/localtime

echo ""
echo "Verify that the link to the correct timezone in /etc/localtime (listed above) is correct"
echo "If so, run ./12-hostname.sh"
