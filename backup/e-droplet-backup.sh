#!/usr/bin/env bash

echo '*****'
echo 'e-droplet backup'
echo `date -Iseconds`
echo '*****'
echo

echo '*** Valvopes ***'
ssh e-droplet docker container exec valvopes-db pg_dump -U postgres data > /mnt/cryptdata/MEGA/Personal/Software/Valvopes/backups/automated_backup.sql
echo "Backup completed successfully."
echo