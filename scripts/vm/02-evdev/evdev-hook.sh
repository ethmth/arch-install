#!/bin/bash

VM_NAME="$1"
EVENT="$2"

CUSTOM_SCRIPT="/usr/local/bin/evdev-attach"

if [[ "$EVENT" == "start" ]] || [[ "$EVENT" == "resume" ]]; then
    logger "libvirt hook: VM '$VM_NAME' is starting. Running evdev-attach."
    /bin/bash "$CUSTOM_SCRIPT" "$VM_NAME"
fi