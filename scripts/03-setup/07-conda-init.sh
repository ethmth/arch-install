#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi

CUR_USER=$(whoami)

# if ! ( cat "/home/$CUR_USER/.bashrc" | grep -q '>>> conda initialize >>>' ); then
# source /opt/anaconda/bin/activate
# conda init bash
# conda config --set auto_activate_base false
# fi