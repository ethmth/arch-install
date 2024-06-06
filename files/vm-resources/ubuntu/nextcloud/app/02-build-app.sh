#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
    echo "This script should not be run with root/sudo privileges."
    exit 1
fi

if ! [ -d "nextcloud-android" ]; then
    echo "Make sure you've cloned the repo first."
    exit 1
fi

cd nextcloud-android
./gradlew assembleRelease

mv app/build/outputs/apk/release/app*.apk ../Nextcloud.apk