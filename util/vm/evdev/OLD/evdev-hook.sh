#!/bin/bash

VM_NAME="$1"
EVENT="$2"

CUSTOM_SCRIPT="/usr/local/bin/evdev-attach"

# Redirect all output to a log file
LOGFILE="/var/log/libvirt/qemu-hook-evdev.log"
exec >>"$LOGFILE" 2>&1

echo "VM_NAME: $VM_NAME"
echo "EVENT: $EVENT"

if [[ "$EVENT" == "started" ]]; then
    logger "libvirt hook: VM '$VM_NAME' is starting. Running evdev-attach."
    /bin/bash "$CUSTOM_SCRIPT" "$VM_NAME"
fi