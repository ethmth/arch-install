#!/bin/bash

docker exec -it nextcloud-db /usr/bin/mariadb --user=nextcloud --password=password nextcloud

# DELETE FROM oc_file_locks WHERE true;