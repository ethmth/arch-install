#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script must not be run with root/sudo privileges."
	exit 1
fi

if ! [ -f "switch-script.sh" ]; then
	echo "Run this in the same directory as ./switch-script.sh"
	exit 1
fi

if ! ( cat "/etc/hosts" | grep -q "nextcloud.local" ); then
    sudo sh -c "echo '127.0.0.1     nextcloud.local' >> /etc/hosts"
fi

chmod +rx switch-script.sh
cp switch-script.sh ~/switch-script.sh
chmod +rx ~/switch-script.sh

./switch-script.sh $1