#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "Do not run this script as sudo/root."
	exit 1
fi

CUR_USER=$(whoami)
source /home/$CUR_USER/install-scripts/values.conf

cd /home/$CUR_USER/openair-vpn/
bash ./set_vars.sh
bash ./install_to_bin.sh
cd
rm -rf /home/$CUR_USER/openair-vpn/