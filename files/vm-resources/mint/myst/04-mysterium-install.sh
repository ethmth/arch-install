#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script must not be run with root/sudo privileges."
	exit 1
fi

CUR_USER=$(whoami)

curl https://api.github.com/repos/mysteriumnetwork/mysterium-vpn-desktop/releases/latest > /tmp/out.html

CONTENTS=$(cat /tmp/out.html)

asset_url=$(echo "$CONTENTS" | grep -o '"browser_download_url": "[^"]*' | cut -d'"' -f4)

deb_dl=$(echo "$asset_url" | grep ".deb")

mkdir -p /home/$CUR_USER/deb

wget -O /home/$CUR_USER/deb/mysterium-vpn-desktop_amd64.deb  --content-disposition $deb_dl

cd /home/$CUR_USER/deb

sudo apt install -y ./mysterium-vpn-desktop_amd64.deb