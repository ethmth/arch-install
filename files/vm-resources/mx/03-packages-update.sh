#!/bin/bash

if [[ $EUID -ne 0 ]]; then
        echo "This script should be run with root/sudo privileges."
        exit 1
fi

update-rc.d -f packagekit remove

packages="
spice-vdagent
qemu-guest-agent
vim
nano
curl
wget
openssh-server
apparmor
flatpak
proxychains
tsocks
thunar
gthumb
mpv
qterminal
vlc
yt-dlp
gallery-dl
docker.io
docker-compose
nmap
neofetch
python3
python3-venv
python3-pip
python3-bs4
python3-selenium
npm
net-tools
speedtest-cli
netcat-openbsd
build-essential
dkms
make
cmake
ffmpeg
httrack
samba
gcc
libelf-dev
gvfs-fuse
gvfs-backends
tmux
plocate
wireguard
golang
rdate
leap-archive-keyring
libavcodec-extra
gstreamer1.0-libav
whois
squid
openvpn
network-manager-openvpn
unzip
xvfb
libxi6
libgconf-2-4
p7zip-full
aria2
catfish
libgmp-dev
libpcap-dev
libbz2-dev
jq
ca-certificates
kate
feh
rtl8812au-dkms
"
packages=${packages//$'\n'/ }
packages=$(echo "$packages" | tr -s ' ' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

apt update && apt upgrade -y
apt install $packages -y

apt remove ufw kdeconnect