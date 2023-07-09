#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script must not be run with root/sudo privileges."
	exit 1
fi

read -p "Are you on VPN-Internal (y/N)? " userInput

if ! ([ "$userInput" == "y" ] || [ "$userInput" == "Y" ]); then
	echo "Then this script shouldn't be necessary (unless Whonix). You should be automatically connected"
	exit 0
fi

CONNECTION=$(nmcli connection show | grep "ethernet")
CONNECTION1=$(echo "$CONNECTION" | head -n 1)
CONNECTION1=$(echo "$CONNECTION1" | awk '{for(i=1; i<=NF-3; i++) printf "%s ", $i; print ""}')
CONNECTION1="${CONNECTION1%% }"

read -p "Enter the phone number: " phoneNumber
ipNumber=$(($phoneNumber + 20))

nmcli connection modify "$CONNECTION1" ipv4.method manual
nmcli connection modify "$CONNECTION1" ipv4.addresses 10.153.153.$ipNumber/24
nmcli connection modify "$CONNECTION1" ipv4.gateway 10.153.153.0
nmcli connection modify "$CONNECTION1" ipv4.dns 10.153.153.0
nmcli connection down "$CONNECTION1"
nmcli connection up "$CONNECTION1"

echo "Manual connection with IP 10.153.153.$ipNumber setup in NetworkManager"
echo "You may want to run this script twice (or until you get no errors)"