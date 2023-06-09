#!/bin/bash

if [[ $EUID -ne 0 ]]; then
        echo "This script should be run with root/sudo privileges."
        exit 1
fi

repos="
ppa:unit193/encryption
"
repos=${repos//$'\n'/ }
repos=$(echo "$repos" | tr -s ' ' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

add-apt-repository $repos
