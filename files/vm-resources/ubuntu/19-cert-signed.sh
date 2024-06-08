#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
    echo "This script should not be run with root/sudo privileges."
    exit 1
fi

if ! [ -d "~/certs" ]; then
    echo "~/certs doesn't exist."
    exit 1
fi

cd ~/certs

openssl genrsa -out nextcloud.test.key 2048


sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | openssl req -x509 -new -nodes -key myCA.key -sha256 -days 1825 -out myCA.pem
    # no password
    .
    .
    .
    .
    .
    nextcloud
    .
    .
    .
EOF
openssl req -new -key nextcloud.test.key -out nextcloud.test.csr
