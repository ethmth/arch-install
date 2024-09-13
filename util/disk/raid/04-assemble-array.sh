#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
	echo "This script must be run with root/sudo privileges."
	exit 1
fi

mdadm --assemble --scan

echo "The RAID array should not be assembled. Reboot and create your filesystem."