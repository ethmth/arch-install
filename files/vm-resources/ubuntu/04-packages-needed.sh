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
apparmor
flatpak
docker.io
docker-compose
nmap
neofetch
python3
python3-venv
python3-pip
net-tools
netcat-openbsd
wireguard
wireguard-go
wireguard-tools
leap-archive-keyring
openvpn
network-manager-openvpn
unzip
jq
fzf
adb
kdeconnect
feh
mpv
"
packages=${packages//$'\n'/ }
packages=$(echo "$packages" | tr -s ' ' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

apt update
apt install $packages -y
