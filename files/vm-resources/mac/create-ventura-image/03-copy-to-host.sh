#!/bin/bash

DEFAULT_IP="192.168.100.1"

echo "You must have ssh enabled on your host for this to work"

ip=$DEFAULT_IP
read -p "Enter your username on the host: " username
read -p "Do you want to use $ip (Y/n)? " userInput

if ([ "$userInput" == "n" ] || [ "$userInput" == "N" ]); then
    read -p "Please enter the ip: " ip
fi

scp -o StrictHostKeyChecking=no ~/Desktop/Ventura.dmg $username@$ip:/home/$username/vm/osx/Ventura.dmg

echo "Ventura.dmg transferred to host at /home/$username/vm/osx/Ventura.dmg"
echo "Please run util/vm/mac/create-ventura-img.sh to finish img creation"
