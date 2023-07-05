#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
        echo "This script should not be run with root/sudo privileges."
        exit 1
fi

CUR_USER=$(whoami)

mkdir -p /home/$CUR_USER/bin

echo "export PATH=\"\$PATH:/home/$CUR_USER/bin\"" >> /home/$CUR_USER/.bashrc
source /home/$CUR_USER/.bashrc