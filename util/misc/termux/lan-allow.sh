#!/bin/bash

# INTERFACE="eth0"

# local_subnet=$(/usr/bin/ip route | grep "$INTERFACE" | grep "/" | cut -d ' ' -f 1)

local_subnet="10.42.0.1/24"

iptables -A OUTPUT -d $local_subnet -p udp --dport 53 -j DROP
iptables -A OUTPUT -d $local_subnet -p tcp --dport 53 -j DROP
iptables -A INPUT -s $local_subnet -p udp --dport 53 -j DROP
iptables -A INPUT -s $local_subnet -p tcp --dport 53 -j DROP
iptables -A OUTPUT -d $local_subnet -j ACCEPT
iptables -A INPUT -s $local_subnet -j ACCEPT