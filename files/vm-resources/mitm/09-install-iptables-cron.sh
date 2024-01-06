#!/bin/bash

if [[ $EUID -ne 0 ]]; then
	echo "This script should be run with root/sudo privileges."
	exit 1
fi

if ! [ -f "./iptables.sh" ]; then
	echo "Make sure you're in the same directory as ./iptables.sh"
	exit 1
fi


cp ./iptables.sh /opt/iptables.sh

(crontab -l 2>/dev/null; echo "@reboot /opt/iptables.sh") | crontab -