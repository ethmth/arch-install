#!/bin/bash

if [[ $EUID -ne 0 ]]; then
	echo "This script should be run with root/sudo privileges."
	exit 1
fi

VERSION="9.1.0-2"

packages=$(ls -1 /var/cache/pacman/pkg/qemu-* | grep "$VERSION-x86_64.pkg.tar.zst" | grep -v ".sig" | awk '{print "file://"$0}')

#pacman -U file:///var/cache/pacman/pkg/qemu-*$VERSION-x86_64.pkg.tar.zst


#awk_str="{print \$0\"-$VERSION-x86_64.pkg.tar.zst\"}"
#packages=$(echo "$packages" | awk '{print "file:///var/cache/pacman/pkg/"$0}' | awk "$awk_str")

#packages=${packages//$'\n'/ }
#packages=$(echo "$packages" | tr -s ' ' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

#echo "$packages"

pacman -U $packages

