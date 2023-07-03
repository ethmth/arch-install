#!/bin/bash

sudo waydroid init

sudo systemctl enableg waydroid-container
sudo systemctl start waydroid-container

waydroid session start

waydroid prop set persist.waydroid.width 768
waydroid prop set persist.waydroid.height 1280