#!/bin/bash

sudo waydroid init

sudo systemctl enable waydroid-container
sudo systemctl start waydroid-container

sudo systemctl enable ipforward
sudo systemctl start ipforward

sudo systemctl enable waydroid-session
sudo systemctl start waydroid-session

# waydroid session start

waydroid prop set persist.waydroid.width 768
waydroid prop set persist.waydroid.height 1280


# echo "MUST ENABLE OPENGL AND VIRTIO ACCELERATION FOR THE VM"
# socat tcp-listen:5555,fork,reuseaddr tcp:192.168.240.112:5555


# TODO - Start weston automatically, start waydroid session after weston's started, start socat command, get it working headlessly, setup libhoudini