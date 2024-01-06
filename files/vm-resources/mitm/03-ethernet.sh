#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script must not be run with root/sudo privileges."
	exit 1
fi

if ([ "$1" != "vpn-gw" ] && [ "$1" != "dhcp" ]); then
	echo "Usage: ./03-ethernet.sh <vpn-gw|dhcp>"
fi


CONNECTION=$(nmcli connection show | grep "ethernet")

INTERFACE1="enp1s0"
INTERFACE2="enp2s0"

CONNECTION1=$(echo "$CONNECTION" | grep "$INTERFACE1")
CONNECTION1=$(echo "$CONNECTION1" | awk '{for(i=1; i<=NF-3; i++) printf "%s ", $i; print ""}')
CONNECTION1="${CONNECTION1%% }"
CONNECTION2=$(echo "$CONNECTION" | grep "$INTERFACE2")
CONNECTION2=$(echo "$CONNECTION2" | awk '{for(i=1; i<=NF-3; i++) printf "%s ", $i; print ""}')
CONNECTION2="${CONNECTION2%% }"


if [ "$1" == "vpn-gw" ]; then
	nmcli connection modify "$CONNECTION1" ipv4.method manual
	nmcli connection modify "$CONNECTION1" ipv4.addresses 10.153.153.40/24
	nmcli connection modify "$CONNECTION1" connection.interface-name "$INTERFACE1"
	nmcli connection modify "$CONNECTION1" ipv4.gateway 10.153.153.0
	nmcli connection modify "$CONNECTION1" ipv4.dns 10.153.153.0
	nmcli connection down "$CONNECTION1"
	nmcli connection up "$CONNECTION1"
fi

if [ "$1" == "dhcp" ]; then 
	nmcli connection modify "$CONNECTION1" ipv4.method auto
	nmcli connection modify "$CONNECTION1" connection.interface-name "$INTERFACE1"
	nmcli connection down "$CONNECTION1"
	nmcli connection up "$CONNECTION1"
fi

nmcli connection modify "$CONNECTION2" ipv4.method shared
nmcli connection modify "$CONNECTION2" connection.interface-name "$INTERFACE2"
nmcli connection modify "$CONNECTION2" ipv4.addresses 10.154.154.0/24
nmcli connection modify "$CONNECTION2" ipv4.dhcp-client-id ""
nmcli connection modify "$CONNECTION2" ipv4.dhcp-timeout 0
nmcli connection modify "$CONNECTION2" ipv4.dhcp-send-hostname no
nmcli connection modify "$CONNECTION2" ipv4.dhcp-hostname ""
nmcli connection down "$CONNECTION2"
nmcli connection up "$CONNECTION2"

echo "Run this script until you get no errors/hangs"