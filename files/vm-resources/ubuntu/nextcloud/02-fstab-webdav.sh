#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi

CUR_USER=$(whoami)

fstab_string="http://localhost:8080/remote.php/dav/files/admin/Local /mnt/nextcloud davfs rw,user,uid=$CUR_USER,noauto 0 0"
sudo sh -c "echo \"$fstab_string\" >> /etc/fstab"

