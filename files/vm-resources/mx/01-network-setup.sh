#!/bin/bash

CONNECTION=$(nmcli connection show | grep "ethernet" | awk '{for(i=1; i<=NF-3; i++) printf "%s ", $i; print ""}')
CONNECTION="${CONNECTION%% }"

# CONNECTION1=$(echo "$CONNECTION" | head -n 1)
CONNECTION1=$(echo "$CONNECTION" | grep "1")
CONNECTION1="${CONNECTION1%% }"
# CONNECTION2=$(echo "$CONNECTION" | tail -n 1)
CONNECTION2=$(echo "$CONNECTION" | grep "2")
CONNECTION2="${CONNECTION2%% }"

# CONNECTION1="eth0"
# CONNECTION2="eth1"

INTERFACE1="eth0"
INTERFACE2="eth1"

nmcli connection modify "$CONNECTION1" ipv4.method manual
nmcli connection modify "$CONNECTION1" ipv4.addresses 10.152.152.15/18
nmcli connection modify "$CONNECTION1" connection.interface-name "$INTERFACE1"
nmcli connection modify "$CONNECTION1" ipv4.gateway 10.152.152.10
nmcli connection modify "$CONNECTION1" ipv4.dns 10.152.152.10
nmcli connection down "$CONNECTION1"
nmcli connection up "$CONNECTION1"

nmcli connection modify "$CONNECTION2" ipv4.method shared
nmcli connection modify "$CONNECTION2" connection.interface-name "$INTERFACE2"
nmcli connection down "$CONNECTION2"
nmcli connection up "$CONNECTION2"