#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi

CUR_USER=$(whoami)

sudo sh -c "echo 'SUBSYSTEM==\"vfio\", OWNER=\"$CUR_USER\", GROUP=\"libvirt\", MODE=\"0660\"' > /etc/udev/rules.d/98-vfio.rules"

echo "Udev rules written. Run ./02-enable-iommu.sh"
