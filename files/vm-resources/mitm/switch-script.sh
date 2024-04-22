#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script must not be run with root/sudo privileges."
	exit 1
fi

INTERFACE1="enp2s0"
INTERFACE2="enp3s0"

CONNECTION1="Wired connection 1"
CONNECTION2="Wired connection 2"


if [ "$1" == "vpn" ]; then
	nmcli connection modify "$CONNECTION1" ipv4.method manual
	nmcli connection modify "$CONNECTION1" ipv4.addresses 10.152.153.40/24
	nmcli connection modify "$CONNECTION1" connection.interface-name "$INTERFACE1"
	nmcli connection modify "$CONNECTION1" ipv4.gateway 10.152.153.10
	nmcli connection modify "$CONNECTION1" ipv4.dns 10.152.153.10
	nmcli connection down "$CONNECTION1"
	nmcli connection up "$CONNECTION1"
elif [ "$1" == "tor" ]; then 
	nmcli connection modify "$CONNECTION1" ipv4.method manual
	nmcli connection modify "$CONNECTION1" ipv4.addresses 10.152.153.40/18
	nmcli connection modify "$CONNECTION1" connection.interface-name "$INTERFACE1"
	nmcli connection modify "$CONNECTION1" ipv4.gateway 10.152.152.10
	nmcli connection modify "$CONNECTION1" ipv4.dns 10.152.152.10
	nmcli connection down "$CONNECTION1"
	nmcli connection up "$CONNECTION1"
elif [ "$1" == "dhcp" ]; then 
	nmcli connection modify "$CONNECTION1" ipv4.method auto
	nmcli connection modify "$CONNECTION1" connection.interface-name "$INTERFACE1"
	nmcli connection down "$CONNECTION1"
	nmcli connection up "$CONNECTION1"
else
    echo "Usage: ./switch-script.sh <vpn|tor|dhcp>"
    exit 1
fi

echo "Run this script until you get no errors/hangs"