#!/bin/bash

hwclock --systohc

# Locale Gen
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

# Hostname
read -p "Please input your desired hostname: " hostname
read -p "Is '$hostname' your desired hostname (N for No, otherwise Yes)? " userInput

while ([ "$userInput" == "N" ] || [ "$userInput" == "n" ]); do
    read -p "Please input your desired hostname: " hostname
    read -p "Is '$hostname' your desired hostname (N for No, otherwise Yes)? " userInput
done
echo "Hostname: $hostname"
echo "$hostname" > /etc/hostname

# Network Configuration
echo "" >> /etc/hosts
echo "127.0.0.1     localhost" >> /etc/hosts
echo "::1           localhost" >> /etc/hosts
echo "127.0.1.1     $hostname.localdomain $hostname" >> /etc/hosts

echo "Contents of /etc/hostname:"
cat /etc/hostname
echo "Contents of /etc/hosts:"
cat /etc/hosts

echo ""
echo "Verify that the information above is correct"
echo "If so, run ./13-users.sh"
