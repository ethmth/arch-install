#!/bin/bash

# memories
VERSION="v7.3.1"
REPO="pulsejet/memories"

if ! [ -d "nextcloud/apps" ]; then
    echo "In wrong folder"
    exit 1
fi

if [ -d "nextcloud/apps/memories" ]; then
    sudo rm -rf nextcloud/apps/memories
fi

RELEASE_ID=$(curl -s "https://api.github.com/repos/$REPO/releases/tags/$VERSION" | jq -r '.id')

if [ "$RELEASE_ID" == "null" ]; then
  echo "Release not found or authentication failed"
  exit 1
fi

ASSET_URL=$(curl -s "https://api.github.com/repos/$REPO/releases/$RELEASE_ID/assets" | jq -r '.[] | select(.name | endswith(".tar.gz")) | .browser_download_url')

if [ -z "$ASSET_URL" ]; then
  echo "No file found in the release assets"
  exit 1
fi

curl -L -o memories.tar.gz "$ASSET_URL"

if ! [ -f "memories.tar.gz" ]; then
  echo "File download failed."
  exit 1
fi

sudo tar -xvf memories.tar.gz -C nextcloud/apps