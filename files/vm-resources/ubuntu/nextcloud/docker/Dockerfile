FROM nextcloud:stable

RUN apt update && apt install -y ffmpeg

# USER www-data
# RUN /var/www/html/occ config:system:set enable_previews --value=true --type=boolean
# RUN /var/www/html/occ config:system:set enabledPreviewProviders 0 --value="OC\\Preview\\Movie"
# RUN /var/www/html/occ config:system:set enabledPreviewProviders 1 --value="OC\\Preview\\PNG"
# RUN /var/www/html/occ config:system:set enabledPreviewProviders 2 --value="OC\\Preview\\JPEG"
# RUN /var/www/html/occ config:system:set enabledPreviewProviders 3 --value="OC\\Preview\\GIF"
# RUN /var/www/html/occ config:system:set enabledPreviewProviders 4 --value="OC\\Preview\\BMP"
# RUN /var/www/html/occ config:system:set enabledPreviewProviders 5 --value="OC\\Preview\\XBitmap"
# RUN /var/www/html/occ config:system:set enabledPreviewProviders 6 --value="OC\\Preview\\MP3"
# RUN /var/www/html/occ config:system:set enabledPreviewProviders 7 --value="OC\\Preview\\MP4"
# RUN /var/www/html/occ config:system:set enabledPreviewProviders 8 --value="OC\\Preview\\TXT"
# RUN /var/www/html/occ config:system:set enabledPreviewProviders 9 --value="OC\\Preview\\MarkDown"
# RUN /var/www/html/occ config:system:set enabledPreviewProviders 10 --value="OC\\Preview\\PDF"