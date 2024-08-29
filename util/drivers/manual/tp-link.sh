#!/bin/bash

if [[ $EUID -ne 0 ]]; then
	echo "This script must be run with root/sudo privileges."
	exit 1
fi

git clone --depth 1 https://github.com/aircrack-ng/rtl8812au.git /tmp/rtl8812au

DRIVER_VERSION=$(grep "#define DRIVERVERSION" /tmp/rtl8812au/include/rtw_version.h | awk '{print $3}' | tr -d v\")
KERNEL=$(uname -r)

cd /tmp/rtl8812au
#make dkms_install

mkdir -vp /usr/src/8812au-$DRIVER_VERSION
cp -r * /usr/src/8812au-$DRIVER_VERSION
dkms add -m 8812au -v $DRIVER_VERSION -k $KERNEL
dkms build -m 8812au -v $DRIVER_VERSION -k $KERNEL
dkms install -m 8812au -v $DRIVER_VERSION -k $KERNEL
dkms status -m 8812au

