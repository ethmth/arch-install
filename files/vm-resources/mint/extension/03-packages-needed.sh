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
neofetch
net-tools
netcat-openbsd
wireguard
wireguard-go
wireguard-tools
openvpn
network-manager-openvpn
unzip
jq
fzf
autossh
python3
"
# for building lokinet
packages+="
build-essential
cmake
git
libcap-dev
pkg-config
automake
libtool
libuv1-dev
libsodium-dev
libzmq3-dev
libcurl4-openssl-dev
libevent-dev nettle-dev
libunbound-dev
libssl-dev
nlohmann-json3-dev
"

packages=${packages//$'\n'/ }
packages=$(echo "$packages" | tr -s ' ' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

apt update
apt install $packages -y

echo "Note: Disable screen locking in 'Light Locker' and set display resolution in 'Display'"
