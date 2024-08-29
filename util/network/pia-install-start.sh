#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
        echo "This script should not be run with root/sudo privileges."
        exit 1
fi

CUR_USER=$(whoami)
source /home/$CUR_USER/arch-install/config/network-interface.conf

read -p "Are you on ARM architecture (Y for Yes, otherwise No)? " onArm

ARM=0
if ([ "$onArm" == "Y" ] || [ "$onArm" == "y" ]); then
	ARM=1
fi

url=""
if (( ARM )); then 
	url=$(curl 'https://www.privateinternetaccess.com/download/linux-vpn' -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:113.0) Gecko/20100101 Firefox/113.0' | grep "https://installers.privateinternetaccess.com/download/pia-linux" | grep -o 'href="[^"]*"' | awk -F '"' '{print $2}' | grep "arm64" | head -1)
else
	url=$(curl 'https://www.privateinternetaccess.com/download/linux-vpn' -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:113.0) Gecko/20100101 Firefox/113.0' | grep "https://installers.privateinternetaccess.com/download/pia-linux" | grep -o 'href="[^"]*"' | awk -F '"' '{print $2}' | head -1)
fi

mkdir -p /home/$CUR_USER/scripts/pia-installer
wget -O /home/$CUR_USER/scripts/pia-installer/pia.run $url
bash /home/$CUR_USER/scripts/pia-installer/pia.run

piactl set allowlan false
piactl set protocol openvpn
piactl set requestportforward false

piactl background enable

if [ -d "/home/$CUR_USER/scripts/pia-ip" ]; then
    echo "Scripts already installed"
else
    git clone https://github.com/ethmth/pia-ip /home/$CUR_USER/scripts/pia-ip
    cp /home/$CUR_USER/scripts/pia-ip/.env.example /home/$CUR_USER/scripts/pia-ip/.env
    bash /home/$CUR_USER/arch-install/util/kernel/config-update.sh /home/$CUR_USER/scripts/pia-ip/pia-fwd.sh "ABSOLUTE_PATH=\'/home/$CUR_USER/scripts/pia-ip\'"

    sed -i "s/wlan0/$NETWORK_INTERFACE/g" /home/$CUR_USER/scripts/pia-ip/.env
fi


echo "Edit the /home/$CUR_USER/scripts/pia-ip/.env file with the correct values."
echo "When done, run ./pia-install-finish.sh"
echo "vim /home/$CUR_USER/scripts/pia-ip/.env"
