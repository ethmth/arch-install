#!/bin/bash

if [[ $EUID -ne 0 ]]; then
	echo "This script should be run with root/sudo privileges."
	exit 1
fi

virsh -c qemu:///system net-autostart default
virsh -c qemu:///system net-autostart default