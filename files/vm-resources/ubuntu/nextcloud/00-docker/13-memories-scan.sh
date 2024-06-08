#!/bin/bash

docker exec -it nextcloud-app su -s /bin/bash -c "/var/www/html/occ files:scan --verbose --no-interaction --path=/admin/files/Local" www-data
