#!/bin/bash

# Directory to check
MOUNT_DIR="/media/veracrypt1"

# Check if the directory is mounted
while ! mountpoint -q "$MOUNT_DIR"; do
    echo "$MOUNT_DIR is not mounted. Waiting..."
    sleep 5
done

echo "$MOUNT_DIR is mounted. Proceeding..."
