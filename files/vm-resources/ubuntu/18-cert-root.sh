#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
    echo "This script should not be run with root/sudo privileges."
    exit 1
fi

if [ -d "$HOME/certs" ]; then
    echo "~/certs already exists. Remove it to continue"
    exit 1
fi

mkdir -p ~/certs
cd ~/certs

export PASSWORD=""
openssl genrsa -des3 -passout env:PASSWORD -out myCA.key 2048

export PASSWORD=""
openssl req -x509 -new -nodes -key myCA.key -sha256 -passin env:PASSWORD -days 36500 -out myCA.pem <<EOF
.
.
.
.
.
Nextcloud Local Common Name
.
EOF

sudo cp ~/certs/myCA.pem /usr/local/share/ca-certificates/myCA.crt
sudo update-ca-certificates
