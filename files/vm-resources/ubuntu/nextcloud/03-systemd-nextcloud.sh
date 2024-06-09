#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi

CUR_USER=$(whoami)

if ! [ -f "check_and_delete_mount.sh" ]; then
	echo "check_and_delete_mount.sh doesn't exist."
	exit 1
fi

sudo cp check_and_delete_mount.sh /usr/local/bin/check_and_delete_mount.sh
sudo chmod +rx /usr/local/bin/check_and_delete_mount.sh

CHECK_CONTENTS="[Unit]
Description=Check if /mnt/veracrypt1 is a mountpoint on startup. If not, delete it.
After=local-fs.target remote-fs.target
Before=docker.service

[Service]
Type=oneshot
ExecStart=/usr/local/bin/check_and_delete_mount.sh

[Install]
WantedBy=multi-user.target
"

DOWN_CONTENTS="[Unit]
Description=Run docker-compose down on startup.
After=network.target check-mount.service docker.service
Requires=check-mount.service

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
After=nextcloud-down.service check-mount.service docker.service
Requires=nextcloud-down.service check-mount.service

[Service]
Type=oneshot
WorkingDirectory=/home/$CUR_USER/programs/nextcloud
ExecStart=/usr/bin/docker compose up -d
User=$CUR_USER

[Install]
WantedBy=multi-user.target
"

sudo sh -c "echo \"$CHECK_CONTENTS\" >> /etc/systemd/system/check-mount.service"
sudo sh -c "echo \"$DOWN_CONTENTS\" >> /etc/systemd/system/nextcloud-down.service"
sudo sh -c "echo \"$UP_CONTENTS\" >> /etc/systemd/system/nextcloud-up.service"
sudo systemctl enable check-mount.service
sudo systemctl enable nextcloud-down.service
sudo systemctl enable nextcloud-up.service

