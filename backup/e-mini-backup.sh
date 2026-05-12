#!/usr/bin/env bash

echo '*****'
echo 'e-mini backup'
echo `date -Iseconds`
echo '*****'
echo

echo '*** gitea-repo-backup ***'
rsync -az --info=stats2 --mkpath e-mini-local:/home/e/docker/gitea-repo-backup/backups/ /mnt/cryptdata/MEGA/Personal/GithubBackups/GiteaBackups
echo
