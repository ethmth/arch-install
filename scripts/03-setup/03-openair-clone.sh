#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi

CUR_USER=$(whoami)
source /home/$CUR_USER/arch-install/config/system.conf
source /home/$CUR_USER/arch-install/config/network-interface.conf

git clone https://github.com/ethmth/openair-vpn.git /home/$CUR_USER/openair-vpn

cp /home/$CUR_USER/openair-vpn/vars/vars.conf.example /home/$CUR_USER/openair-vpn/vars/vars.conf
cp /home/$CUR_USER/openair-vpn/vars/install_location.conf.example /home/$CUR_USER/openair-vpn/vars/install_location.conf

sed -i "s/eth0/$NETWORK_INTERFACE/g" /home/$CUR_USER/openair-vpn/vars/vars.conf
sed -i "s|/home/me|/home/$CUR_USER|g" /home/$CUR_USER/openair-vpn/vars/vars.conf


vim /home/$CUR_USER/openair-vpn/vars/vars.conf

mkdir -p /home/$CUR_USER/.vpn

echo "Navigate to https://airvpn.org/generator/ and download AirVPN.zip into ~/.vpn/"
echo "Select Linux, OpenVPN TCP 443, Single Server (Invert Selection to Select All) "
echo "Edit /home/$CUR_USER/openair-vpn/vars/vars.conf"
echo "When DONE EDITING vars.conf, run ./05-openair-install.sh"
echo "vim /home/$CUR_USER/openair-vpn/vars/vars.conf"
