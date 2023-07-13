#!/bin/bash

NAME="archivebox"

if ! [[ $EUID -ne 0 ]]; then
        echo "This script should not be run with root/sudo privileges."
        exit 1
fi

CUR_USER=$(whoami)

if ! [ -e "../$NAME/docker-compose.yml" ]; then
	echo "Make sure you run this script in the same directory as ../$NAME/docker-compose.yml"
	exit 1
fi

LOC="/home/$CUR_USER"

if ! [ -d "$LOC" ]; then
    echo "Your location is not available. Is the disk mounted? Do you have access?"
	exit 1
fi

LOC="$LOC/programs"
mkdir -p $LOC

if ! [ -e "$LOC/$NAME/data/sonic" ]; then
mkdir -p $LOC/$NAME/data/sonic
chmod -R 777 $LOC/$NAME/data
fi

# if ! [ -e "$LOC/$NAME/etc" ]; then
# mkdir -p $LOC/$NAME/etc
# chmod -R 777 $LOC/$NAME/etc
# fi

cp docker-compose.yml $LOC/$NAME/docker-compose.yml
cp sonic.cfg $LOC/$NAME/sonic.cfg

cd $LOC/$NAME/
docker-compose up --build -d

docker-compose run archivebox manage createsuperuser

echo "$NAME installed in $LOC and started."
echo "Run 'docker-compose up --build -d' to run it and 'docker-compose stop' to stop it."
echo "cd $LOC/$NAME"