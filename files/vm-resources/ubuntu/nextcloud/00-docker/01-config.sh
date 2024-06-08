#!/bin/bash

# enable previews
docker exec -it nextcloud-app su -s /bin/bash -c "/var/www/html/occ config:system:set enable_previews --value=true --type=boolean" www-data
docker exec -it nextcloud-app su -s /bin/bash -c "/var/www/html/occ config:system:set preview_max_memory --value=-1 --type=integer" www-data

docker exec -it nextcloud-app su -s /bin/bash -c "/var/www/html/occ config:system:set enabledPreviewProviders 0 --value='OC\\Preview\\Movie'" www-data
docker exec -it nextcloud-app su -s /bin/bash -c "/var/www/html/occ config:system:set enabledPreviewProviders 1 --value='OC\\Preview\\Imaginary'" www-data
docker exec -it nextcloud-app su -s /bin/bash -c "/var/www/html/occ config:system:set enabledPreviewProviders 2 --value='OC\\Preview\\MP3'" www-data
docker exec -it nextcloud-app su -s /bin/bash -c "/var/www/html/occ config:system:set enabledPreviewProviders 3 --value='OC\\Preview\\MP4'" www-data
docker exec -it nextcloud-app su -s /bin/bash -c "/var/www/html/occ config:system:set enabledPreviewProviders 4 --value='OC\\Preview\\TXT'" www-data
docker exec -it nextcloud-app su -s /bin/bash -c "/var/www/html/occ config:system:set enabledPreviewProviders 5 --value='OC\\Preview\\MarkDown'" www-data
docker exec -it nextcloud-app su -s /bin/bash -c "/var/www/html/occ config:system:set enabledPreviewProviders 6 --value='OC\\Preview\\PDF'" www-data
docker exec -it nextcloud-app su -s /bin/bash -c "/var/www/html/occ config:system:set enabledPreviewProviders 7 --value='OC\\Preview\\GIF'" www-data

docker exec -it nextcloud-app su -s /bin/bash -c "/var/www/html/occ config:system:set preview_imaginary_url --value='http://imaginary:9000'" www-data

# add trusted domain
docker exec -it nextcloud-app su -s /bin/bash -c "/var/www/html/occ config:system:set trusted_domains 1 --value='nextcloud.local'" www-data
docker exec -it nextcloud-app su -s /bin/bash -c "/var/www/html/occ config:system:set trusted_domains 2 --value='web'" www-data
docker exec -it nextcloud-app su -s /bin/bash -c "/var/www/html/occ config:system:set trusted_domains 3 --value='host.docker.internal'" www-data
docker exec -it nextcloud-app su -s /bin/bash -c "/var/www/html/occ config:system:set trusted_domains 4 --value='10.152.153.14'" www-data

# set umask
docker exec -it nextcloud-app su -s /bin/bash -c "/var/www/html/occ config:system:set localstorage.umask --value=0000" www-data

# enable External Files app
docker exec -it nextcloud-app su -s /bin/bash -c "/var/www/html/occ app:enable files_external" www-data

# disable update checker/internet checks
docker exec -it nextcloud-app su -s /bin/bash -c "/var/www/html/occ config:system:set updatechecker --value=false --type=boolean" www-data
docker exec -it nextcloud-app su -s /bin/bash -c "/var/www/html/occ config:system:set has_internet_connection --value=false --type=boolean" www-data
docker exec -it nextcloud-app su -s /bin/bash -c "/var/www/html/occ config:system:set upgrade.disable-web --value=true --type=boolean" www-data
docker exec -it nextcloud-app su -s /bin/bash -c "/var/www/html/occ config:system:set knowledgebaseenabled --value=false --type=boolean" www-data

# change default app
docker exec -it nextcloud-app su -s /bin/bash -c "/var/www/html/occ config:system:set defaultapp --value='files,gallery'" www-data

# setup redis
docker exec -it nextcloud-app su -s /bin/bash -c "/var/www/html/occ config:system:set memcache.local --value='\\OC\\Memcache\\Redis'" www-data
docker exec -it nextcloud-app su -s /bin/bash -c "/var/www/html/occ config:system:set memcache.distributed --value='\\OC\\Memcache\\Redis'" www-data
docker exec -it nextcloud-app su -s /bin/bash -c "/var/www/html/occ config:system:set memcache.locking --value='\\OC\\Memcache\\Redis'" www-data

# disable unused apps - TODO
docker exec -it nextcloud-app su -s /bin/bash -c "/var/www/html/occ app:disable files_sharing" www-data
docker exec -it nextcloud-app su -s /bin/bash -c "/var/www/html/occ app:disable federation" www-data
docker exec -it nextcloud-app su -s /bin/bash -c "/var/www/html/occ app:disable files_downloadlimit" www-data
docker exec -it nextcloud-app su -s /bin/bash -c "/var/www/html/occ app:disable weather_status" www-data
docker exec -it nextcloud-app su -s /bin/bash -c "/var/www/html/occ app:disable user_status" www-data
docker exec -it nextcloud-app su -s /bin/bash -c "/var/www/html/occ app:disable survey_client" www-data
docker exec -it nextcloud-app su -s /bin/bash -c "/var/www/html/occ app:disable circles" www-data
docker exec -it nextcloud-app su -s /bin/bash -c "/var/www/html/occ app:disable updatenotification" www-data
docker exec -it nextcloud-app su -s /bin/bash -c "/var/www/html/occ app:disable support" www-data
docker exec -it nextcloud-app su -s /bin/bash -c "/var/www/html/occ app:disable sharebymail" www-data
docker exec -it nextcloud-app su -s /bin/bash -c "/var/www/html/occ app:disable related_resources" www-data
docker exec -it nextcloud-app su -s /bin/bash -c "/var/www/html/occ app:disable recommendations" www-data
docker exec -it nextcloud-app su -s /bin/bash -c "/var/www/html/occ app:disable nextcloud_announcements" www-data
docker exec -it nextcloud-app su -s /bin/bash -c "/var/www/html/occ app:disable files_reminders" www-data
docker exec -it nextcloud-app su -s /bin/bash -c "/var/www/html/occ app:disable contactsinteraction" www-data
