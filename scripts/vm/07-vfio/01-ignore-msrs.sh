#!/bin/bash

if [[ $EUID -ne 0 ]]; then
	echo "This script should be run with root/sudo privileges."
	exit 1
fi

echo "options kvm ignore_msrs=1 report_ignored_msrs=0" > /etc/modprobe.d/kvm.conf

cat /etc/modprobe.d/kvm.conf

echo "Ignore msrs modprobe rules written. Run ./02-enable-iommu.sh"
echo "cat /sys/module/kvm/parameters/ignore_msrs to check (after next reboot, not needed now)"