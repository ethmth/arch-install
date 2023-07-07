#!/bin/bash

if [[ $EUID -ne 0 ]]; then
        echo "This script should be run with root/sudo privileges."
        exit 1
fi

packages="
spice-vdagent
qemu-guest-agent
nano
wget
openssh-server
nmap
neofetch
python3
python3-venv
python3-pip
net-tools
netcat-openbsd
unzip
jq
fzf
adb
scrcpy
feh
mpv
lzip
"
packages=${packages//$'\n'/ }
packages=$(echo "$packages" | tr -s ' ' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

apt update
apt install $packages -y

echo "When this is finished, run ./10-waydroid-script.sh"