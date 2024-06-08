#!/bin/bash

if [[ $EUID -ne 0 ]]; then
        echo "This script should be run with root/sudo privileges."
        exit 1
fi

#python3.9
#python3.9-venv
#gh
#mariadb-client-core
packages="
kdeconnect
pipx
trimage
smartmontools
gparted
gprename
ncdu
ubuntu-restricted-extras
gobuster
mitmproxy
xdg-desktop-portal-gtk
snap
git-lfs
proxychains
tsocks
thunar
tumbler
gthumb
qterminal
vlc
yt-dlp
gallery-dl
john 
hashcat 
keepassxc
python3-full
python3-selenium
python3-bs4
python3-requests
python3-tqdm
python3-django
python3-phonenumbers
python3-progressbar
python3-autopep8
python3-validators
python3-maxminddb
python3-aiohttp
python3-aiodns
python-is-python3
npm
speedtest-cli
openssl
openjdk-8-jdk
openjdk-17-jdk
openjdk-11-jdk
build-essential
dkms
make
cmake 
ffmpeg 
httrack 
samba 
gcc  
p7zip-full 
qbittorrent 
gvfs-fuse 
gvfs-backends 
libelf-dev 
tmux 
plocate 
wireguard 
golang 
rdate 
leap-archive-keyring 
libavcodec-extra 
gstreamer1.0-libav 
whois
scrcpy 
squid
libxi6 
ssh
sshpass
rar
catfish
aria2
libcompress-raw-lzma-perl
yasm
pkg-config
libgmp-dev
libpcap-dev
libbz2-dev
mesa-utils 
kate
ca-certificates
xvfb
veracrypt
unrar
torbrowser-launcher
apktool
droidlysis
pv
hexyl
qimgv
"

packages+="
docker-ce
docker-ce-cli
containerd.io
docker-buildx-plugin
docker-compose-plugin
"


packages=${packages//$'\n'/ }
packages=$(echo "$packages" | tr -s ' ' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

apt update && apt upgrade -y
apt install $packages -y
