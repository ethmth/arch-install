#!/bin/bash

DOMAIN="nextcloud.local"

if ! [[ $EUID -ne 0 ]]; then
    echo "This script should not be run with root/sudo privileges."
    exit 1
fi

if ! [ -d "$HOME/certs" ]; then
    echo "~/certs doesn't exist."
    exit 1
fi

if ! [ -f "$DOMAIN.ext" ]; then
    echo "No $DOMAIN.ext"
    exit 1
fi

cp $DOMAIN.ext ~/certs

cd ~/certs

openssl genrsa -out $DOMAIN.key 2048

openssl req -new -key $DOMAIN.key -out $DOMAIN.csr <<EOF
.
.
.
.
.
Nextcloud Local Common Name
.
.
.
EOF

export PASSWORD=""
openssl x509 -req -in $DOMAIN.csr -CA myCA.pem -CAkey myCA.key -passin env:PASSWORD \
-CAcreateserial -out $DOMAIN.crt -days 36500 -sha256 -extfile $DOMAIN.ext

