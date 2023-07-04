#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi

CUR_USER=$(whoami)

mkdir -p /sharepoint
mkdir -p /home/$CUR_USER/share
mount -t 9p -o trans=virtio /sharepoint /home/$CUR_USER/share

# chmod -R 777 /home/$CUR_USER/share

fstab_string="/sharepoint  /home/$CUR_USER/share  9p  trans=virtio  0  0"

sudo sh -c "echo \"$fstab_string\" >> /etc/fstab"

echo "The ~/share directory should mount on boot now (added to /etc/fstab)"
