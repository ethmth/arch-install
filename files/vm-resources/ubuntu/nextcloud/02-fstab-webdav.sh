#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi

CUR_USER=$(whoami)

sudo mkdir -p /mnt/nextcloud

fstab_string="https://nextcloud.local/remote.php/dav/files/admin/Local /mnt/nextcloud davfs rw,user,uid=$CUR_USER,_netdav 0 0"
sudo sh -c "echo \"$fstab_string\" >> /etc/fstab"

