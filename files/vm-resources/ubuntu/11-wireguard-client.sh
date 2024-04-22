#!/bin/bash

if [[ $EUID -ne 0 ]]; then
	echo "This script should be run with root/sudo privileges."
	exit 1
fi

read -p "Enter your username on the Wireguard machine: " username

mkdir -p /opt/wireguard-client
chmod -R 777 /opt/wireguard-client

scp -r $username@10.152.153.15:/opt/wireguard-server/config/peer2 /opt/wireguard-client

if ! [ -e "/opt/wireguard-client/peer2/peer2.conf" ]; then
	echo "Make sure you have created peer2 on the $username machine"
	exit 1
fi

chmod -R 777 /opt/wireguard-client

mkdir -p /etc/wireguard
cp /opt/wireguard-client/peer2/peer2.conf /etc/wireguard/wg0.conf
rm -rf /opt/wireguard-client

sed -i '/DNS/d' /etc/wireguard/wg0.conf
sed -i '/AllowedIPs/d' /etc/wireguard/wg0.conf
echo "AllowedIPs = 10.13.13.0/24" >> /etc/wireguard/wg0.conf

ufw allow 51820/udp

wg-quick up wg0
systemctl enable wg-quick@wg0

echo "Restart"
