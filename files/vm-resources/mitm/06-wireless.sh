#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script must not be run with root/sudo privileges."
	exit 1
fi

CONNECTION="mitm"
INTERFACE=$(iw dev | grep Interface | awk '{print $2}' | head -1)
subnet="10.154.155.0/24"

echo -n "Please enter desired Wifi password:" 
read -s password
echo

nmcli connection delete $CONNECTION
nmcli connection add type wifi ifname $INTERFACE con-name $CONNECTION autoconnect yes ssid $CONNECTION ipv4.method shared ipv4.address $subnet
nmcli connection modify "$CONNECTION" ipv4.dhcp-client-id ""
nmcli connection modify "$CONNECTION" ipv4.dhcp-timeout 0
nmcli connection modify "$CONNECTION" ipv4.dhcp-send-hostname no
nmcli connection modify "$CONNECTION" ipv4.dhcp-hostname ""
nmcli connection modify $CONNECTION 802-11-wireless-security.key-mgmt wpa-psk 802-11-wireless-security.psk $password
nmcli connection up $CONNECTION