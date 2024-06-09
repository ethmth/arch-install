#!/bin/bash

# sleep 15

MOUNT_POINT="/media/veracrypt1"

if [ -d "$MOUNT_POINT" ]; then
    # if ! [ -d "$MOUNT_POINT/ext" ]; then
    #     echo "$MOUNT_POINT exists. Deleting..."
    #     rm -rf "$MOUNT_POINT"
    # fi
    rmdir "$MOUNT_POINT"
fi


# if ! mountpoint -q "$MOUNT_POINT"; then
#     echo "$MOUNT_POINT is not a mountpoint. Deleting..."
#     rm -rf "$MOUNT_POINT"
# else
#     echo "$MOUNT_POINT is a mountpoint. No action taken."
# fi