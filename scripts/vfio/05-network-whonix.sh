#!/bin/bash

if [[ $EUID -ne 0 ]]; then
	echo "This script should be run with root/sudo privileges."
	exit 1
fi

# virsh -c qemu:///system net-autostart default
# virsh -c qemu:///system net-start default

mkdir -p /tmp/whonix
# curl https://www.whonix.org/wiki/KVM#Network_Start > /tmp/whonix/whonix.html
download=$(cat /tmp/whonix/whonix.html | grep "download.whonix.org" | grep "Whonix-XFCE" | grep "qcow2" | grep -v "archive" | grep -v "asc" | head -n 1 | awk -F'"' '{print $2}')

wget --output-document=/tmp/whonix/Whonix-XFCE-1.Intel_AMD64.qcow2.libvirt.xz $download