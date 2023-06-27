#!/bin/bash

packages="
vlc
librewolf
firefox
chromium
flutter
cocoapods
android-studio
"

packages=${packages//$'\n'/ }
packages=$(echo "$packages" | tr -s ' ' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

brew install $packages

echo "Package installation complete"
