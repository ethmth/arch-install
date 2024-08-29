#!/bin/sh
# DEVS="0000:07:00.0 0000:07:00.1" # Uncomment this for actual use
if [ -z "$(ls -A /sys/class/iommu)" ]; then
        exit 0
fi
for DEV in $DEVS; do
        echo "vfio-pci" > "/sys/bus/pci/devices/$DEV/driver_override"
done