#!/bin/bash

if [[ $EUID -ne 0 ]]; then
        echo "This script should be run with root/sudo privileges."
        exit 1
fi

packages="
snap
git-lfs
proxychains
tsocks
thunar
gthumb
mpv
qterminal
vlc
yt-dlp
youtube-dl
gallery-dl
john 
hashcat 
keepassxc 
python3-selenium
python3-bs4
npm
speedtest-cli
openjdk-8-jdk
openjdk-17-jdk
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
adb 
scrcpy 
squid
libxi6 
libgconf-2-4 
default-jdk 
ssh 
chrome-gnome-shell 
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
feh
xvfb
"
packages=${packages//$'\n'/ }
packages=$(echo "$packages" | tr -s ' ' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

apt update && apt upgrade -y
apt install $packages -y
