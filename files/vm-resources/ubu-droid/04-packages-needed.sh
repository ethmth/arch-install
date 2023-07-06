#!/bin/bash

if [[ $EUID -ne 0 ]]; then
        echo "This script should be run with root/sudo privileges."
        exit 1
fi

packages="
spice-vdagent
qemu-guest-agent
git
vim
nano
curl
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
weston
socat
lzip
ca-certificates
"
packages=${packages//$'\n'/ }
packages=$(echo "$packages" | tr -s ' ' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

apt update
apt install $packages -y
