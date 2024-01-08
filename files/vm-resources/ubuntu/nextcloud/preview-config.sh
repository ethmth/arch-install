#!/bin/bash

docker exec -it nextcloud_app_1 su -s /bin/bash -c "/var/www/html/occ config:system:set enable_previews --value=true --type=boolean" www-data

docker exec -it nextcloud_app_1 su -s /bin/bash -c "/var/www/html/occ config:system:set enabledPreviewProviders 0 --value='OC\\Preview\\Movie'" www-data
docker exec -it nextcloud_app_1 su -s /bin/bash -c "/var/www/html/occ config:system:set enabledPreviewProviders 1 --value='OC\\Preview\\PNG'" www-data
docker exec -it nextcloud_app_1 su -s /bin/bash -c "/var/www/html/occ config:system:set enabledPreviewProviders 2 --value='OC\\Preview\\JPEG'" www-data
docker exec -it nextcloud_app_1 su -s /bin/bash -c "/var/www/html/occ config:system:set enabledPreviewProviders 3 --value='OC\\Preview\\GIF'" www-data
docker exec -it nextcloud_app_1 su -s /bin/bash -c "/var/www/html/occ config:system:set enabledPreviewProviders 4 --value='OC\\Preview\\BMP'" www-data
docker exec -it nextcloud_app_1 su -s /bin/bash -c "/var/www/html/occ config:system:set enabledPreviewProviders 5 --value='OC\\Preview\\XBitmap'" www-data
docker exec -it nextcloud_app_1 su -s /bin/bash -c "/var/www/html/occ config:system:set enabledPreviewProviders 6 --value='OC\\Preview\\MP3'" www-data
docker exec -it nextcloud_app_1 su -s /bin/bash -c "/var/www/html/occ config:system:set enabledPreviewProviders 7 --value='OC\\Preview\\MP4'" www-data
docker exec -it nextcloud_app_1 su -s /bin/bash -c "/var/www/html/occ config:system:set enabledPreviewProviders 8 --value='OC\\Preview\\TXT'" www-data
docker exec -it nextcloud_app_1 su -s /bin/bash -c "/var/www/html/occ config:system:set enabledPreviewProviders 9 --value='OC\\Preview\\MarkDown'" www-data
docker exec -it nextcloud_app_1 su -s /bin/bash -c "/var/www/html/occ config:system:set enabledPreviewProviders 10 --value='OC\\Preview\\PDF'" www-data
