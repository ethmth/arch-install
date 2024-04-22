#!/bin/bash

if [[ $EUID -ne 0 ]]; then
	echo "This script should be run with root/sudo privileges."
	exit 1
fi

read -p "Enter your username on the Wireguard machine: " username

mkdir -p /opt/wireguard-client
chmod -R 777 /opt/wireguard-client

scp -r $username@10.152.153.15:/home/$username/programs/openvpn/my_client2.ovpn /etc/openvpn/client/client.conf

if ! [ -e "/etc/openvpn/client/client.conf" ]; then
	echo "Make sure you have created my_client2.ovpn on the $username machine"
	exit 1
fi

ufw allow 1194/udp

systemctl enable openvpn-client@client

echo "Restart"
