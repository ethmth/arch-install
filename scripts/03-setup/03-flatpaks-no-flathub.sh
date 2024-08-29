#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi

CUR_USER=$(whoami)
source /home/$CUR_USER/arch-install/config/system.conf


CW_VERSION="v4.19.4"
CW_REPO="cake-tech/cake_wallet"

RELEASE_ID=$(curl -s "https://api.github.com/repos/$CW_REPO/releases/tags/$CW_VERSION" | jq -r '.id')

if [ "$RELEASE_ID" == "null" ]; then
  echo "Release not found or authentication failed"
  exit 1
fi

echo "Release ID: $RELEASE_ID"

ASSET_URL=$(curl -s "https://api.github.com/repos/$CW_REPO/releases/$RELEASE_ID/assets" | jq -r '.[] | select(.name | endswith(".flatpak")) | .browser_download_url')

if [ -z "$ASSET_URL" ]; then
  echo "No .flatpak file found in the release assets"
  exit 1
fi

echo "Downloading .flatpak file from $ASSET_URL"

curl -L -o /tmp/cw.flatpak "$ASSET_URL"

sudo flatpak install --noninteractive /tmp/cw.flatpak


echo "Verify that the installation of the flatpaks was successful"
echo "==========================================================="
echo "Next, run ./04-openair-clone.sh"
