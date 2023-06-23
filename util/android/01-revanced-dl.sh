#!/bin/bash

api_url="https://api.github.com/repos/revanced/revanced-cli/releases/latest"
release_info=$(curl -s "$api_url")

tag_name=$(echo "$release_info" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
download_url=$(echo "$release_info" | grep '"browser_download_url":' | sed -E 's/.*"([^"]+)".*/\1/')

wget -O revanced-cli.jar $download_url

api_url="https://api.github.com/repos/revanced/revanced-patches/releases/latest"
release_info=$(curl -s "$api_url")

tag_name=$(echo "$release_info" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
download_url=$(echo "$release_info" | grep '"browser_download_url":' | sed -E 's/.*"([^"]+)".*/\1/' | grep ".jar")

wget -O revanced-patches.jar $download_url

