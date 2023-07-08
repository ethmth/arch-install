#!/bin/bash

if [[ $EUID -ne 0 ]]; then
	echo "This script should be run with root/sudo privileges."
	exit 1
fi

SCRIPT_PATH=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT_PATH")

if ! [ -f "$SCRIPT_DIR/autossh.service" ]; then
    echo "$SCRIPT_DIR/autossh.service not found"
    exit 1
fi

echo "Running ssh-keygen"
sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | ssh-keygen
    # default dir 
    # no password
    # no password confirm
EOF

read -p "Enter your username on the Wireguard machine: " username

mkdir -p /tmp/sshtemp/.ssh
cp /root/.ssh/id_rsa.pub /tmp/sshtemp/.ssh/authorized_keys

scp -r /tmp/sshtemp/.ssh $username@10.153.153.18:/home/$username/.ssh

cp $SCRIPT_DIR/autossh.service /etc/systemd/system/autossh.service
sed -i "s/USERNAME/$username/g" /etc/systemd/system/autossh.service
systemctl enable autossh.service

echo "If ssh setup was successful, you should end up in the remote shell"
echo "Exit. Then, reboot"

ssh $username@10.153.153.18
