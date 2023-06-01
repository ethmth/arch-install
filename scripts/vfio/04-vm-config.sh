#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
        echo "This script should not be run with root/sudo privileges."
        exit 1
fi

CUR_USER=$(whoami)
OFILE="/home/$CUR_USER/arch-install/config/vm.conf"

WHONIX_LOC=$(lsblk --noheadings -o MOUNTPOINTS | grep -v '^$' | grep -v "/boot" | fzf --prompt="Select your desired Whonix installation location")
# WHONIX_LOC=$("$(lsblk --noheadings -o MOUNTPOINTS | grep -v '^$' | grep -v "/boot")\nCancel" | fzf --prompt="Select your desired Whonix installation location")

if ([ "$WHONIX_LOC" == "" ] || [ "$WHONIX_LOC" == "Cancel" ]); then
    echo "Nothing was selected"
    exit 1
fi

if [ "$WHONIX_LOC" == "/" ]; then
echo "Are you sure you want to install in the root directory? We will use "
fi

echo "Using $WHONIX_LOC to install whonix"

exit 0


echo "WHONIX_LOC=$WHONIX_LOC" > $OFILE
echo "POOP=$POOP" >> $OFILE

cat $OFILE

echo "Verify the contents of $OFILE (Output above)"
echo "You can manually edit $OFILE if needed"
echo "If successful, run ./05-network-whonix.sh"
