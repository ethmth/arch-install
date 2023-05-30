#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "Do not run this script as sudo/root."
	exit 1
fi

CUR_USER=$(whoami)
source /home/$CUR_USER/install-scripts/values.conf

git clone https://github.com/ethmth/openair-vpn.git /home/$CUR_USER/openair-vpn

cp /home/$CUR_USER/openair-vpn/vars/vars.conf.example /home/$CUR_USER/openair-vpn/vars/vars.conf
cp /home/$CUR_USER/openair-vpn/vars/install_location.conf.example /home/$CUR_USER/openair-vpn/vars/install_location.conf

echo "Navigate to https://airvpn.org/generator/ and download AirVPN.zip into ~/.vpn/"
echo "Edit /home/$CUR_USER/openair-vpn/vars/vars.conf"
echo "Run /home/$CUR_USER/install-scripts/openair-install-2.sh"