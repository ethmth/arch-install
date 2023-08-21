#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi

CUR_USER=$(whoami)


cd /home/$CUR_USER/programs/openvpn/
docker-compose down

cd ../
sudo rm -rf /home/$CUR_USER/programs/openvpn