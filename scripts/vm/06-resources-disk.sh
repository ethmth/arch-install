#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
        echo "This script should not be run with root/sudo privileges."
        exit 1
fi

CUR_USER=$(whoami)

mkisofs -o /home/$CUR_USER/arch-install/files/resources.iso -J -R /home/$CUR_USER/arch-install/files/vm-resources

chmod g+rw /home/$CUR_USER/arch-install/files/resources.iso
chmod o+rw /home/$CUR_USER/arch-install/files/resources.iso

echo "If the iso file at /home/$CUR_USER/arch-install/files/resources.iso was created successfully,"
echo "Run ./05-network-default.sh to define and start the default network."