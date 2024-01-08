#!/bin/bash

docker exec -it nextcloud_app_1 su -s /bin/bash -c "/var/www/html/occ files:scan --all" www-data