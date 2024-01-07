#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script must not be run with root/sudo privileges."
	exit 1
fi

CONNECTION=$(nmcli connection show | grep "ethernet")
CONNECTION1=$(echo "$CONNECTION" | head -n 1)
CONNECTION1=$(echo "$CONNECTION1" | awk '{for(i=1; i<=NF-3; i++) printf "%s ", $i; print ""}')
CONNECTION1="${CONNECTION1%% }"

read -p "Enter the phone number: " phoneNumber
ipNumber=$(($phoneNumber + 20))

if [ "$1" == "vpn-gw" ]; then
    nmcli connection modify "$CONNECTION1" ipv4.method manual
    nmcli connection modify "$CONNECTION1" ipv4.addresses 10.153.153.$ipNumber/24
    nmcli connection modify "$CONNECTION1" ipv4.gateway 10.153.153.10
    nmcli connection modify "$CONNECTION1" ipv4.dns 10.153.153.10
    nmcli connection down "$CONNECTION1"
    nmcli connection up "$CONNECTION1"
elif [ "$1" == "mitm" ]; then
    nmcli connection modify "$CONNECTION1" ipv4.method manual
    nmcli connection modify "$CONNECTION1" ipv4.addresses 10.153.153.$ipNumber/24
    nmcli connection modify "$CONNECTION1" ipv4.gateway 10.154.154.40
    nmcli connection modify "$CONNECTION1" ipv4.dns 10.154.154.40
    nmcli connection down "$CONNECTION1"
    nmcli connection up "$CONNECTION1"
else
    echo "Usage: ./switch-script.sh <vpn-gw|mitm>"
    exit 1
fi