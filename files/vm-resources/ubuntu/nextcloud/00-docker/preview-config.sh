#!/bin/bash

# enable previews
docker exec -it nextcloud-app su -s /bin/bash -c "/var/www/html/occ config:system:set enable_previews --value=true --type=boolean" www-data
docker exec -it nextcloud-app su -s /bin/bash -c "/var/www/html/occ config:system:set preview_max_memory --value=-1 --type=integer" www-data


docker exec -it nextcloud-app su -s /bin/bash -c "/var/www/html/occ config:system:set enabledPreviewProviders 0 --value='OC\\Preview\\Movie'" www-data
docker exec -it nextcloud-app su -s /bin/bash -c "/var/www/html/occ config:system:set enabledPreviewProviders 1 --value='OC\\Preview\\PNG'" www-data
docker exec -it nextcloud-app su -s /bin/bash -c "/var/www/html/occ config:system:set enabledPreviewProviders 2 --value='OC\\Preview\\JPEG'" www-data
docker exec -it nextcloud-app su -s /bin/bash -c "/var/www/html/occ config:system:set enabledPreviewProviders 3 --value='OC\\Preview\\GIF'" www-data
docker exec -it nextcloud-app su -s /bin/bash -c "/var/www/html/occ config:system:set enabledPreviewProviders 4 --value='OC\\Preview\\BMP'" www-data
docker exec -it nextcloud-app su -s /bin/bash -c "/var/www/html/occ config:system:set enabledPreviewProviders 5 --value='OC\\Preview\\XBitmap'" www-data
docker exec -it nextcloud-app su -s /bin/bash -c "/var/www/html/occ config:system:set enabledPreviewProviders 6 --value='OC\\Preview\\MP3'" www-data
docker exec -it nextcloud-app su -s /bin/bash -c "/var/www/html/occ config:system:set enabledPreviewProviders 7 --value='OC\\Preview\\MP4'" www-data
docker exec -it nextcloud-app su -s /bin/bash -c "/var/www/html/occ config:system:set enabledPreviewProviders 8 --value='OC\\Preview\\TXT'" www-data
docker exec -it nextcloud-app su -s /bin/bash -c "/var/www/html/occ config:system:set enabledPreviewProviders 9 --value='OC\\Preview\\MarkDown'" www-data
docker exec -it nextcloud-app su -s /bin/bash -c "/var/www/html/occ config:system:set enabledPreviewProviders 10 --value='OC\\Preview\\PDF'" www-data

# add trusted domain
docker exec -it nextcloud-app su -s /bin/bash -c "/var/www/html/occ config:system:set trusted_domains 2 --value='10.152.153.14'" www-data

# set umask
docker exec -it nextcloud-app su -s /bin/bash -c "/var/www/html/occ config:system:set localstorage.umask --value=0000" www-data

# enable External Files app
docker exec -it nextcloud-app su -s /bin/bash -c "/var/www/html/occ app:enable files_external" www-data

# disable update checker/internet checks
docker exec -it nextcloud-app su -s /bin/bash -c "/var/www/html/occ config:system:set updatechecker --value=false --type=boolean" www-data
docker exec -it nextcloud-app su -s /bin/bash -c "/var/www/html/occ config:system:set has_internet_connection --value=false --type=boolean" www-data
docker exec -it nextcloud-app su -s /bin/bash -c "/var/www/html/occ config:system:set upgrade.disable-web --value=true --type=boolean" www-data

# disable filelocking
docker exec -it nextcloud-app su -s /bin/bash -c "/var/www/html/occ config:system:set filelocking.enabled --value=false --type=boolean" www-data
