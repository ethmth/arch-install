#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi

CUR_USER=$(whoami)
source /home/$CUR_USER/arch-install/config/vm.conf

if [ "$WHONIX_LOC" == "" ]; then
	echo "Whonix location not set in /home/$CUR_USER/arch-install/config/vm.conf"
	echo "Run ./04-vm-config.sh first to set location"
	exit 1
fi

if ! [ -d "$WHONIX_LOC" ]; then
    echo "Your configured location is not available. Is the disk mounted?"
	echo "Try mounting the disk, and optionally running ./04-vm-config.sh"
	exit 1
fi

# mkdir -p $WHONIX_LOC/whonix
tar -xvf $WHONIX_LOC/whonix/Whonix*.libvirt.xz -C $WHONIX_LOC/whonix/

touch $WHONIX_LOC/whonix/WHONIX_BINARY_LICENSE_AGREEMENT_accepted

cp $WHONIX_LOC/whonix/Whonix-Gateway*.xml $WHONIX_LOC/whonix/Whonix-Gateway.xml 
cp $WHONIX_LOC/whonix/Whonix-Workstation*.xml $WHONIX_LOC/whonix/Whonix-Workstation.xml 
cp $WHONIX_LOC/whonix/Whonix_external*.xml $WHONIX_LOC/whonix/Whonix_external.xml 
cp $WHONIX_LOC/whonix/Whonix_internal*.xml $WHONIX_LOC/whonix/Whonix_internal.xml 