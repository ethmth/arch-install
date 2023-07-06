#!/bin/bash

if [[ $EUID -ne 0 ]]; then
	echo "This script must not be run with root/sudo privileges."
	exit 1
fi

read -p "Are you on Whonix-Internal (y/N)? " userInput

if ! ([ "$userInput" == "y" ] || [ "$userInput" == "Y" ]); then
	echo "Then this script shouldn't be necessary. You should be automatically connected"
	exit 0
fi

CONNECTION=$(nmcli connection show | grep "ethernet" | awk '{for(i=1; i<=NF-3; i++) printf "%s ", $i; print ""}')
CONNECTION="${CONNECTION%% }"

read -p "Enter the phone number: " phoneNumber

ipNumber=$(($phoneNumber + 20))
ipNumber="10.152.152.$ipNumber"

nmcli connection modify "$CONNECTION" ipv4.method manual
nmcli connection modify "$CONNECTION" ipv4.addresses 10.152.152.$ipNumber/18
nmcli connection modify "$CONNECTION" ipv4.gateway 10.152.152.10
nmcli connection modify "$CONNECTION" ipv4.dns 10.152.152.10
nmcli connection down "$CONNECTION"
nmcli connection up "$CONNECTION"

echo "Manual connection with IP 10.152.152.$ipNumber setup in NetworkManager"
echo "You may want to run this script twice (or until you get no errors)"