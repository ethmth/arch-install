#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi

# sudo systemctl start vmware-networks-configuration.service
# sudo systemctl enable vmware-networks.service
# sudo systemctl enable vmware-usbarbitrator.service