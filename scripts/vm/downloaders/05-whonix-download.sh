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

mkdir -p $WHONIX_LOC/whonix
curl https://www.whonix.org/wiki/KVM#Network_Start > $WHONIX_LOC/whonix/whonix.html
download=$(cat $WHONIX_LOC/whonix/whonix.html | grep "download.whonix.org" | grep "Whonix-XFCE" | grep "qcow2" | grep -v "archive" | grep -v "asc" | head -n 1 | awk -F'"' '{print $2}')

wget --output-document=$WHONIX_LOC/whonix/Whonix-XFCE-1.Intel_AMD64.qcow2.libvirt.xz $download

echo "Image downloaded into $WHONIX_LOC/whonix"
echo "Run ./06-whonix-unzip.sh to unzip and edit the images before adding them"
