#!/bin/bash

# memories
VERSION="android/1.12"
REPO="pulsejet/memories"

RELEASE_ID=$(curl -s "https://api.github.com/repos/$REPO/releases/tags/$VERSION" | jq -r '.id')

if [ "$RELEASE_ID" == "null" ]; then
  echo "Release not found or authentication failed"
  exit 1
fi

ASSET_URL=$(curl -s "https://api.github.com/repos/$REPO/releases/$RELEASE_ID/assets" | jq -r '.[] | select(.name | endswith(".apk")) | .browser_download_url')

if [ -z "$ASSET_URL" ]; then
  echo "No file found in the release assets"
  exit 1
fi

curl -L -o memories.apk "$ASSET_URL"