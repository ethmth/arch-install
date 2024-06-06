#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi

CUR_USER=$(whoami)

davfs_string="http://localhost:8080/remote.php/dav/files/admin/Local admin admin"
sudo sh -c "echo \"$davfs_string\" >> /etc/davfs2/secrets"

