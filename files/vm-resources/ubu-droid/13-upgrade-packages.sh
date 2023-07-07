#!/bin/bash

if [[ $EUID -ne 0 ]]; then
        echo "This script should be run with root/sudo privileges."
        exit 1
fi

sudo apt update && sudo apt upgrade -y