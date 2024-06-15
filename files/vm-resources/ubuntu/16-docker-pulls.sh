#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should NOT be run with root/sudo privileges."
	exit 1
fi

# h2non/imaginary:latest
dockers="
alpine:latest
postgres:alpine
redis:alpine
nextcloud:fpm
caddy:alpine
"

dockers=${dockers//$'\n'/ }
dockers=$(echo "$dockers" | tr -s ' ' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

echo "This script still needs to be tested. If it don't work, fix it." 
for docker in $dockers; do
	docker pull $docker
done
