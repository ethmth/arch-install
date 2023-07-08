#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script must not be run with root/sudo privileges."
	exit 1
fi

CONNECTION=$(nmcli connection show | grep "ethernet")
CONNECTION1=$(echo "$CONNECTION" | head -n 1)
CONNECTION1=$(echo "$CONNECTION1" | awk '{for(i=1; i<=NF-3; i++) printf "%s ", $i; print ""}')
CONNECTION1="${CONNECTION1%% }"

nmcli connection modify "$CONNECTION1" ipv4.method manual
nmcli connection modify "$CONNECTION1" ipv4.addresses 10.153.153.18/24
nmcli connection modify "$CONNECTION1" ipv4.gateway 10.153.153.0
nmcli connection modify "$CONNECTION1" ipv4.dns 10.152.152.10
nmcli connection down "$CONNECTION1"
nmcli connection up "$CONNECTION1"

echo "You may have to/want to run this twice for good measure if you get an error message"
echo "The settings may not persist over boot. Create a new connection profile, and set that."
