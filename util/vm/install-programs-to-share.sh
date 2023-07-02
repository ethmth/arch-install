#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
        echo "This script should not be run with root/sudo privileges."
        exit 1
fi

CUR_USER=$(whoami)


FOLDER_NAME="Nothing"

FOLDER_NAME=$(ls -1 /home/$CUR_USER/.local/share/Cryptomator/mnt | fzf --prompt "Select project folder to move to shared")

if ([ "$FOLDER_NAME" == "" ] || [ "$FOLDER_NAME" == "Nothing" ]); then
    echo "No Folder selected."
    exit 1
fi

SOURCE="/home/$CUR_USER/.local/share/Cryptomator/mnt/$FOLDER_NAME"

LOC=$(lsblk --noheadings -o MOUNTPOINTS | grep -v '^$' | grep -v "/boot" | fzf --prompt="Select your desired destination location")

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

DESTINATION="$LOC/vm/share/$FOLDER_NAME"

cp -r $SOURCE $DESTINATION
echo "Copied $SOURCE to $DESTINATION"
echo "Run ./install-programs.sh in the VM to install contents"