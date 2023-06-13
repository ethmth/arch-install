#!/bin/bash

if [[ $EUID -ne 0 ]]; then
	echo "This script should be run with root/sudo privileges."
	exit 1
fi

read -p "Enter your username on the Wireguard machine: " username

mkdir -p /opt/wireguard-client
chmod -R 777 /opt/wireguard-client

scp -r $username@10.152.152.15:/opt/wireguard-server/config/peer2 /opt/wireguard-client

if ! [ -e "/opt/wireguard-client/peer2/peer2.conf" ]; then
	echo "Make sure you have created peer2 on the $username machine"
	exit 1
fi

chmod -R 777 /opt/wireguard-client

# mkdir -p /etc/wireguard
# cp /opt/wireguard-client/peer2/peer2.conf /etc/wireguard/wg0.conf
# rm -rf /opt/wireguard-client

# sudo sed -i 's|^AllowedIPs$|AllowedIPs = 10.13.13.0/24|' /etc/wireguard/wg0.conf
# awk '{ if ($0 == "AllowedIPs") { print "AllowedIPs = 10.13.13.0/24" } else { print $0 } }' /etc/wireguard/wg0.conf > /tmp/tmpconfig && mv /tmp/tmpconfig /etc/wireguard/wg0.conf

# sed -i '/AllowedIPs/d' /etc/wireguard/wg0.conf
# echo "AllowedIPs = 10.13.13.0/24" >> /etc/wireguard/wg0.conf

# wg-quick up wg0
# systemctl enable wg-quick@wg0

PRIVATE_KEY=$(cat /opt/wireguard-client/peer2/peer2.conf | grep "PrivateKey" | cut -d '=' -f 2- | sed -e 's/^[[:space:]]*//')
PUBLIC_KEY=$(cat /opt/wireguard-client/peer2/peer2.conf | grep "PublicKey" | cut -d '=' -f 2- | sed -e 's/^[[:space:]]*//')
PRESHARED_KEY=$(cat /opt/wireguard-client/peer2/peer2.conf | grep "PresharedKey" | cut -d '=' -f 2- | sed -e 's/^[[:space:]]*//')


sed -i "s/WIREGUARD_PRIVATE_KEY_HERE/$PRIVATE_KEY/g" /etc/nixos/configuration.nix
sed -i "s/WIREGUARD_PUBLIC_KEY_HERE/$PUBLIC_KEY/g" /etc/nixos/configuration.nix
sed -i "s/WIREGUARD_PRESHARED_KEY_HERE/$PRESHARED_KEY/g" /etc/nixos/configuration.nix

nixos-rebuild switch
