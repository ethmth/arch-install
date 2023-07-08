#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script must not be run with root/sudo privileges."
	exit 1
fi

CUR_USER=$(whoami)

mkdir -p /home/$CUR_USER/deb

wget -O /home/$CUR_USER/deb/MullvadVPN_amd64.deb --content-disposition https://mullvad.net/download/app/deb/latest

cd /home/$CUR_USER/deb

sudo apt install -y ./MullvadVPN_amd64.deb

echo "Configure Mullvad. Recommended: Launch on Startup, Auto Connect, Local Network Sharing, OpenVPN TCP, Custom: 10.152.152.10 DNS"