#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi

CUR_USER=$(whoami)
source /home/$CUR_USER/arch-install/config/system.conf

cd /home/$CUR_USER/openair-vpn/
bash ./set_vars.sh
bash ./install_to_bin.sh
cd /home/$CUR_USER/openair-vpn/systemd
sudo ./install-services.sh
cd

# echo "Install root crontab:"
# sudo crontab /home/$CUR_USER/openair-vpn/crontab-root

# rm -rf /home/$CUR_USER/openair-vpn/

echo "Restart and verify that openvpn connects successfully automatically"
echo "Next, you may want to configure other disk drives using the scripts found in /home/$CUR_USER/arch-install/util/disk"
echo "Also, you may want to configure your Desktop Environment and most commonly used software"
echo "Such as KDE Plasma or Hyprland, Thunar, Alacritty or QTerminal, Librewolf, Brave, MEGASync (should start up automatically), and more"
echo "Then, you may want to begin setting up vfio/Virtual Machines"
