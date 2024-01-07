#!/bin/bash

if [[ $EUID -ne 0 ]]; then
        echo "This script should be run with root/sudo privileges."
        exit 1
fi

packages="
linux-headers-$(uname -r)
iptables
wireshark-qt
adb
socat
spice-vdagent
qemu-guest-agent
vim
nano
curl
wget
openssh-server
openssl
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
gcc
make
bc
build-essential
git
dkms
rfkill
iw
libelf-dev
cmake
tmux
unzip
jq
ca-certificates
kate
rtl8812au-dkms
openjdk-11-jdk
apktool
droidlysis
scrcpy
whois
"
packages=${packages//$'\n'/ }
packages=$(echo "$packages" | tr -s ' ' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

apt update && apt upgrade -y
apt install $packages -y

apt remove ufw

echo "Restart before proceeding."