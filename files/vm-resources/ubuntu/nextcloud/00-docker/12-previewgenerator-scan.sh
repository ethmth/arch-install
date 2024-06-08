#!/bin/bash

docker exec -it nextcloud-app su -s /bin/bash -c "/var/www/html/occ preview:generate-all" www-data
