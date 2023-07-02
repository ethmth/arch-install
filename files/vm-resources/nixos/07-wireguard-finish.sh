#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi

CONNECTION="wg0"

nmcli connection modify "$CONNECTION" ipv4.method manual
# nmcli connection modify "$CONNECTION" ipv4.addresses 10.152.152.14/18
# nmcli connection modify "$CONNECTION" ipv4.gateway 10.152.152.10
nmcli connection modify "$CONNECTION" ipv4.dns 10.152.152.10
# nmcli connection down "$CONNECTION"
# nmcli connection up "$CONNECTION"

echo "If you go error output, you might have to run this script again."