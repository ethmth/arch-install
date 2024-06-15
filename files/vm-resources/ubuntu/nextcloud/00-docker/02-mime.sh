#!/bin/bash

# Update MIME db
docker exec -it nextcloud-app su -s /bin/bash -c "/var/www/html/occ maintenance:mimetype:update-js" www-data
docker exec -it nextcloud-app su -s /bin/bash -c "/var/www/html/occ maintenance:mimetype:update-db" www-data
