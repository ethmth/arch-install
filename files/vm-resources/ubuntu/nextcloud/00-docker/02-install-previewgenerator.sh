#!/bin/bash

VERSION="v5.5.0"
REPO="nextcloud/previewgenerator"

if ! [ -d "nextcloud/apps" ]; then
    echo "In wrong folder"
    exit 1
fi

if [ -d "nextcloud/apps/previewgenerator" ]; then
    sudo rm -rf nextcloud/apps/previewgenerator
fi

sudo git clone https://github.com/$REPO nextcloud/apps/previewgenerator

cd nextcloud/apps/previewgenerator

sudo git checkout $VERSION