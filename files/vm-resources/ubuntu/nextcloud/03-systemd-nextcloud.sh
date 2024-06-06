#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi

CUR_USER=$(whoami)

CONTENTS="[Unit]
Description=Run docker-compose up on nextcloud on startup.
After=network.target

[Service]
Type=oneshot
WorkingDirectory=/home/$CUR_USER/programs/nextcloud
ExecStart=/usr/bin/docker compose up -d
User=$CUR_USER

[Install]
WantedBy=multi-user.target
"

sudo sh -c "echo \"$CONTENTS\" >> /etc/systemd/system/nextcloud.service"
sudo systemctl enable nextcloud.service

