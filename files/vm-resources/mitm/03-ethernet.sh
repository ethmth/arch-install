#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script must not be run with root/sudo privileges."
	exit 1
fi

if ! [ -f "switch-script.sh" ]; then
	echo "Run this in the same directory as ./switch-script.sh"
	exit 1
fi

INTERFACE1="enp2s0"
INTERFACE2="enp3s0"

CONNECTION1="Wired connection 1"
CONNECTION2="Wired connection 2"

chmod +rx switch-script.sh
cp switch-script.sh ~/switch-script.sh
chmod +rx ~/switch-script.sh

./switch-script.sh $1

nmcli connection modify "$CONNECTION2" ipv4.method shared
nmcli connection modify "$CONNECTION2" connection.interface-name "$INTERFACE2"
nmcli connection modify "$CONNECTION2" ipv4.addresses 10.154.154.40/24
nmcli connection modify "$CONNECTION2" ipv4.dhcp-client-id ""
nmcli connection modify "$CONNECTION2" ipv4.dhcp-timeout 0
nmcli connection modify "$CONNECTION2" ipv4.dhcp-send-hostname no
nmcli connection modify "$CONNECTION2" ipv4.dhcp-hostname ""
nmcli connection down "$CONNECTION2"
nmcli connection up "$CONNECTION2"

echo "Run this script until you get no errors/hangs"