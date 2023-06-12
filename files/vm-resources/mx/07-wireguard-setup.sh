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
echo "Run 'wireguard' to start the container"