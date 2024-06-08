#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi

CUR_USER=$(whoami)


DOWN_CONTENTS="[Unit]
Description=Run docker-compose down on startup.
After=network.target

[Service]
Type=oneshot
WorkingDirectory=/home/$CUR_USER/programs/nextcloud
ExecStart=/usr/bin/docker compose down
User=$CUR_USER

[Install]
WantedBy=multi-user.target
"



UP_CONTENTS="[Unit]
Description=Run docker-compose up on nextcloud on startup.
After=nextcloud-down.service
Requires=nextcloud-down.service

[Service]
Type=oneshot
WorkingDirectory=/home/$CUR_USER/programs/nextcloud
ExecStart=/usr/bin/docker compose up -d
User=$CUR_USER

[Install]
WantedBy=multi-user.target
"

sudo sh -c "echo \"$DOWN_CONTENTS\" >> /etc/systemd/system/nextcloud-down.service"
sudo sh -c "echo \"$UP_CONTENTS\" >> /etc/systemd/system/nextcloud-up.service"
sudo systemctl enable nextcloud-down.service
sudo systemctl enable nextcloud-up.service

