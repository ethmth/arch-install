#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
    echo "This script should not be run with root/sudo privileges."
    exit 1
fi

if ! [ -d "$HOME/certs" ]; then
    echo "~/certs doesn't exist."
    exit 1
fi

if ! [ -f "nextcloudlocal.test.ext" ]; then
    echo "No nextcloudlocal.test.ext"
    exit 1
fi

cp nextcloudlocal.test.ext ~/certs

cd ~/certs

openssl genrsa -out nextcloudlocal.test.key 2048

openssl req -new -key nextcloudlocal.test.key -out nextcloudlocal.test.csr <<EOF
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

#exit 0

#sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | openssl req -x509 -new -nodes -key myCA.key -sha256 -days 1825 -out myCA.pem
#    # no password
#    .
#    .
#    .
#    .
#    .
#    nextcloud
#    .
#    .
#    .
#EOF
#
#openssl req -new -key nextcloud.test.key -out nextcloud.test.csr

export PASSWORD=""
openssl x509 -req -in nextcloudlocal.test.csr -CA myCA.pem -CAkey myCA.key -passin env:PASSWORD \
-CAcreateserial -out nextcloudlocal.test.crt -days 825 -sha256 -extfile nextcloudlocal.test.ext

