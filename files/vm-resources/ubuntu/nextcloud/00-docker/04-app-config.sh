#!/bin/bash

# enable Preview Generator and Memories apps
docker exec -it nextcloud-app su -s /bin/bash -c "/var/www/html/occ app:enable previewgenerator" www-data
docker exec -it nextcloud-app su -s /bin/bash -c "/var/www/html/occ app:enable memories" www-data