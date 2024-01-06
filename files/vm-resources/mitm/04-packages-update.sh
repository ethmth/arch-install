#!/bin/bash

if [[ $EUID -ne 0 ]]; then
        echo "This script should be run with root/sudo privileges."
        exit 1
fi

packages="
iw
socat
spice-vdagent
qemu-guest-agent
vim
nano
curl
wget
openssh-server
proxychains
nmap
neofetch
python3
python3-venv
python3-pip
mitmproxy
net-tools
speedtest-cli
netcat-openbsd
build-essential
dkms
make
cmake
tmux
unzip
jq
ca-certificates
kate
rtl8812au-dkms
"
packages=${packages//$'\n'/ }
packages=$(echo "$packages" | tr -s ' ' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

apt update && apt upgrade -y
apt install $packages -y

apt remove ufw