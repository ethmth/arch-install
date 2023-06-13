#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi

CUR_USER=$(whoami)

read -p "Enter your username on the Wireguard machine: " username

sudo mkdir -p /opt/wireguard-client
sudo chmod -R 777 /opt/wireguard-client

scp -r $username@10.152.152.15:/opt/wireguard-server/config/peer2 /opt/wireguard-client

sudo chmod -R 777 /opt/wireguard-client

sudo mkdir -p /etc/wireguard
sudo cp /opt/wireguard-client/peer2/peer2.conf /etc/wireguard/wg0.conf
sudo rm -rf /opt/wireguard-client

# sudo sed -i 's|^AllowedIPs$|AllowedIPs = 10.13.13.0/24|' /etc/wireguard/wg0.conf
sudo awk '{ if ($0 == "AllowedIPs") { print "AllowedIPs = 10.13.13.0/24" } else { print $0 } }' /etc/wireguard/wg0.conf > /etc/wireguard/wg0.conf.temp && mv /tmp/tmpconfig /etc/wireguard/wg0.conf

sudo wg-quick up wg0
sudo systemctl enable wg-quick@wg0