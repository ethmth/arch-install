#!/bin/bash

sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -runFirstLaunch

echo "Run 'sudo xcodebuild -license' to accept licenses"
echo "Run 'open -a Simulator' (or search Simulator via Spotlight) to open the iPhone simulator"
echo "Run 'flutter doctor --android-licenses' to accept Android Licenses"