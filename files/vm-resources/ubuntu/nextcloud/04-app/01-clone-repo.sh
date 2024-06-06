#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
    echo "This script should not be run with root/sudo privileges."
    exit 1
fi

PR="12161"
REPO="https://github.com/nextcloud/android"

git clone $REPO nextcloud-android

cd nextcloud-android

git fetch origin pull/$PR/head:prfix

git merge prfix