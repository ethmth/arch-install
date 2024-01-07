#!/bin/bash

# iptables -L -n -t nat

if [[ $EUID -ne 0 ]]; then
	echo "This script should be run with root/sudo privileges."
	exit 1
fi

HOST_INTERFACE="enp2s0"
SHARED_INTERFACE="enp3s0"
WIRELESS_INTERFACE=$(iw dev | grep Interface | awk '{print $2}' | head -1)

iptables -t nat -A POSTROUTING -o $HOST_INTERFACE -j MASQUERADE

iptables -A FORWARD -i $HOST_INTERFACE -o $SHARED_INTERFACE -m state --state RELATED,ESTABLISHED -j ACCEPT

iptables -A FORWARD -i $SHARED_INTERFACE -o $HOST_INTERFACE -j ACCEPT

iptables -t nat -A PREROUTING -i $SHARED_INTERFACE -p tcp --dport 80 -j REDIRECT --to-port 8080
iptables -t nat -A PREROUTING -i $SHARED_INTERFACE -p tcp --dport 443 -j REDIRECT --to-port 8080

if [ "$WIRELESS_INTERFACE" != "" ]; then
	iptables -A FORWARD -i $HOST_INTERFACE -o $WIRELESS_INTERFACE -m state --state RELATED,ESTABLISHED -j ACCEPT

	iptables -A FORWARD -i $WIRELESS_INTERFACE -o $HOST_INTERFACE -j ACCEPT

	iptables -t nat -A PREROUTING -i $WIRELESS_INTERFACE -p tcp --dport 80 -j REDIRECT --to-port 8080
	iptables -t nat -A PREROUTING -i $WIRELESS_INTERFACE -p tcp --dport 443 -j REDIRECT --to-port 8080
fi