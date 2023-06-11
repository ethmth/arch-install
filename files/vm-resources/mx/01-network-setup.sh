#!/bin/bash

CONNECTION=$(nmcli connection show | grep "ethernet" | awk '{for(i=1; i<=NF-3; i++) printf "%s ", $i; print ""}')
CONNECTION="${CONNECTION%% }"

nmcli connection modify "$CONNECTION" ipv4.method manual
nmcli connection modify "$CONNECTION" ipv4.addresses 10.152.152.15/18
nmcli connection modify "$CONNECTION" ipv4.gateway 10.152.152.10
nmcli connection modify "$CONNECTION" ipv4.dns 10.152.152.10
nmcli connection down "$CONNECTION"
nmcli connection up "$CONNECTION"