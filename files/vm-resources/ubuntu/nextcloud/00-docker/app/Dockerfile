FROM nextcloud:fpm
RUN apt-get update && apt-get install -y \
    supervisor \
    ffmpeg \
  && rm -rf /var/lib/apt/lists/* \
  && mkdir /var/log/supervisord /var/run/supervisord

COPY supervisord.conf /
COPY preview-generate /etc/cron.d/preview-generate

ENV NEXTCLOUD_UPDATE=1

CMD ["/usr/bin/supervisord", "-c", "/supervisord.conf"]