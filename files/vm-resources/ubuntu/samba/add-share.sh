#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script must not be run with root/sudo privileges."
	exit 1
fi
CUR_USER=$(whoami)

CONTENT='
[Media]

comment = needs username and password to access
path = /media/veracrypt1
browseable = yes
guest ok = yes
writable = no
'

sudo sh -c "echo '$CONTENT' >> /etc/samba/smb.conf"