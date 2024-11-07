#!/bin/bash

if [[ $EUID -ne 0 ]]; then
	echo "This script should be run with root/sudo privileges."
	exit 1
fi

VERSION="9.1.0-2"

pacman -U file:///var/cache/pacman/pkg/qemu-*$VERSION-x86_64.pkg.tar.zst

exit 0

packages="qemu-audio-alsa
qemu-audio-dbus
qemu-audio-jack
qemu-audio-oss
qemu-audio-pa
qemu-audio-pipewire
qemu-audio-sdl
qemu-audio-spice
qemu-base
qemu-block-curl
qemu-block-dmg
qemu-block-nfs
qemu-block-ssh
qemu-chardev-spice
qemu-common
qemu-desktop
qemu-hw-display-qxl
qemu-hw-display-virtio-gpu
qemu-hw-display-virtio-gpu-gl
qemu-hw-display-virtio-gpu-pci
qemu-hw-display-virtio-gpu-pci-gl
qemu-hw-display-virtio-vga
qemu-hw-display-virtio-vga-gl
qemu-hw-s390x-virtio-gpu-ccw
qemu-hw-usb-host
qemu-hw-usb-redirect
qemu-hw-usb-smartcard
qemu-img
qemu-pr-helper
qemu-system-x86
qemu-system-x86-firmware
qemu-tools
qemu-ui-curses
qemu-ui-dbus
qemu-ui-egl-headless
qemu-ui-gtk
qemu-ui-opengl
qemu-ui-sdl
qemu-ui-spice-app
qemu-ui-spice-core
qemu-vhost-user-gpu
"

packages+="qemu-block-gluster
qemu-block-iscsi
qemu-chardev-baum
qemu-emulators-full
qemu-full
qemu-system-aarch64
qemu-system-alpha
qemu-system-arm
qemu-system-avr
qemu-system-cris
qemu-system-hppa
qemu-system-loongarch64
qemu-system-m68k
qemu-system-microblaze
qemu-system-mips
qemu-system-or1k
qemu-system-ppc
qemu-system-riscv
qemu-system-rx
qemu-system-s390x
qemu-system-sh4
qemu-system-sparc
qemu-system-tricore
qemu-system-xtensa
qemu-tests
qemu-user
qemu-vmsr-helper"


awk_str="{print \$0\"-$VERSION-x86_64.pkg.tar.zst\"}"
packages=$(echo "$packages" | awk '{print "file:///var/cache/pacman/pkg/"$0}' | awk "$awk_str")

packages=${packages//$'\n'/ }
packages=$(echo "$packages" | tr -s ' ' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

#echo "$packages"

pacman -U $packages

