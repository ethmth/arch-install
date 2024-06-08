#!/bin/bash

docker exec -it nextcloud-app su -s /bin/bash -c "/var/www/html/occ memories:places-setup" www-data
docker exec -it nextcloud-app su -s /bin/bash -c "/var/www/html/occ memories:index" www-data
