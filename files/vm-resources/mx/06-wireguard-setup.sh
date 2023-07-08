#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi

CUR_USER=$(whoami)

sudo -k mkdir -p /opt/wireguard-server/config

if ! [ -e "wireguard/wireguard" ]; then
	echo "Make sure you run this script in the same directory as ./wireguard/wireguard"
	exit 1
fi

mkdir -p /home/$CUR_USER/programs/wireguard/
cp wireguard/docker-compose.yml /home/$CUR_USER/programs/wireguard/docker-compose.yaml

sudo cp wireguard/wireguard /usr/bin/wireguard
sudo chmod +x /usr/bin/wireguard

sudo chmod -R 777 /opt/wireguard-server

echo "Installed wireguard to bin"
echo "Running 'wireguard' to start the container"

wireguard

echo "Run feh /opt/wireguard-server/config/peer1/"
echo "Use this on Android. Change AllowedIPs in the Wireguard config to 10.13.13.0/24"

echo "Then, run ./wireguard-client.sh on Ubuntu/Nix"