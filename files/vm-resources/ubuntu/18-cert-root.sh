#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
    echo "This script should not be run with root/sudo privileges."
    exit 1
fi

if [ -d "~/certs" ]; then
    echo "~/certs already exists. Remove it to continue"
    exit 1
fi

mkdir -p ~/certs
cd ~/certs

sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | openssl genrsa -des3 -out myCA.key 2048
    # no password
    # no password confirm
EOF

sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | openssl req -x509 -new -nodes -key myCA.key -sha256 -days 1825 -out myCA.pem
    # no password
    .
    .
    .
    .
    .
    My Epic Cert
    .
EOF

sudo cp ~/certs/myCA.pem /usr/local/share/ca-certificates/myCA.crt

sudo update-ca-certificates