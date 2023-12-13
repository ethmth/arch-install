#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script must not be run with root/sudo privileges."
	exit 1
fi

CONNECTION=$(nmcli connection show | grep "ethernet")

INTERFACE1="enp1s0"

CONNECTION1=$(echo "$CONNECTION" | grep "$INTERFACE1")
CONNECTION1=$(echo "$CONNECTION1" | awk '{for(i=1; i<=NF-3; i++) printf "%s ", $i; print ""}')
CONNECTION1="${CONNECTION1%% }"

if [ "$1" == "tor" ]; then
    nmcli connection modify "$CONNECTION1" ipv4.method manual
    nmcli connection modify "$CONNECTION1" ipv4.addresses 10.152.152.21/18
    nmcli connection modify "$CONNECTION1" connection.interface-name "$INTERFACE1"
    nmcli connection modify "$CONNECTION1" ipv4.gateway 10.152.152.10
    nmcli connection modify "$CONNECTION1" ipv4.dns 10.152.152.10
    nmcli connection down "$CONNECTION1"
    nmcli connection up "$CONNECTION1"
elif [ "$1" == "vpn" ]; then
    nmcli connection modify "$CONNECTION1" ipv4.method manual
    nmcli connection modify "$CONNECTION1" ipv4.addresses 10.0.3.15/18
    nmcli connection modify "$CONNECTION1" connection.interface-name "$INTERFACE1"
    nmcli connection modify "$CONNECTION1" ipv4.gateway 10.0.3.2
    nmcli connection modify "$CONNECTION1" ipv4.dns 10.0.3.2
    nmcli connection down "$CONNECTION1"
    nmcli connection up "$CONNECTION1"
else
    echo "Usage: ./switch-script.sh <tor|vpn>"
    exit 1
fi