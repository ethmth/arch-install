#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
        echo "This script should not be run with root/sudo privileges."
        exit 1
fi

CUR_USER=$(whoami)

LOC=$(lsblk --noheadings -o MOUNTPOINTS | grep -v '^$' | grep -v "/boot" | fzf --prompt="Select your desired tavern installation location")

if ([ "$LOC" == "" ] || [ "$LOC" == "Cancel" ]); then
    echo "Nothing was selected"
    echo "Run this script again with target drive mounted."
    exit 1
fi

if [ "$LOC" == "/" ]; then
    LOC="/home/$CUR_USER"
fi

if ! [ -d "$LOC" ]; then
    echo "Your location is not available. Is the disk mounted? Do you have access?"
	exit 1
fi

DISK=$LOC
LOC="$LOC/programs"
mkdir -p $LOC

git clone --depth 1 https://github.com/TavernAI/TavernAI.git $LOC/TavernAI

cd $LOC/TavernAI

sed -i "s/8000:8000/8010:8000/g" $LOC/TavernAI/docker-compose.yml
sed -i "s/const whitelistMode = true;/const whitelistMode = false;/g" $LOC/TavernAI/config.conf

echo '' >> $LOC/TavernAI/docker-compose.yml
echo '    extra_hosts:' >> $LOC/TavernAI/docker-compose.yml
echo '      - "host.docker.internal:host-gateway"' >> $LOC/TavernAI/docker-compose.yml

echo "Docker version installed to $LOC."
echo "Run 'docker compose up --build' to start."
echo "cd $LOC/TavernAI"
