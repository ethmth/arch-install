#!/bin/bash

if [[ $EUID -ne 0 ]]; then
	echo "This script should be run with root/sudo privileges."
	exit 1
fi

if [ -f "dnsmasq.conf" ]; then
    echo "dnsmasq.conf not found."
    exit 1
fi

cp dnsmasq.conf /etc/dnsmasq.conf