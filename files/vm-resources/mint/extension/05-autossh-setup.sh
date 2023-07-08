#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi
CUR_USER=$(whoami)

echo "Running ssh-keygen"
sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | ssh-keygen
    # default dir 
    # no password
    # no password confirm
EOF

read -p "Enter your username on the Wireguard machine: " username

scp /home/$CUR_USER/.ssh/id_rsa.pub $username@10.153.153.18:/home/$username/.ssh/authorized_keys

echo "@reboot /usr/bin/autossh -D 0.0.0.0:6969 -N $username@10.153.153.18" > /tmp/crontemp

crontab /tmp/crontemp

echo "Set crontab:"
crontab -l

echo "If ssh setup was successful, you should end up in the remote shell"
echo "Exit. Then, reboot"

ssh $username@10.153.153.18
