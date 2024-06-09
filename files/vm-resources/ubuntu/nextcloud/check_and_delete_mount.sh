#!/bin/bash

MOUNT_POINT="/media/veracrypt1"

if [ -d "$MOUNT_POINT" ]; then
    rmdir "$MOUNT_POINT"
fi