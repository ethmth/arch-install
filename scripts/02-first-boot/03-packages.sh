#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi

CUR_USER=$(whoami)
source /home/$CUR_USER/arch-install/config/system.conf

packages="
tk
gstreamer
gst-libav
btrfs-progs
dmidecode
egl-wayland
os-prober
isoimagewriter
partitionmanager
bc
radeontop
gnome-disk-utility
ipcalc
stress
llvm
crash
makedumpfile
kernelshark
trace-cmd
rust
mercurial
gperf
repo
bash-completion
gamescope
signify
gnome-keyring
libsecret
seahorse
avahi
nss-mdns
iw
screen
ntp
traceroute
redis
wireguard-tools
inetutils
libvncserver
freerdp
sshpass
expect
proxychains-ng
htop
btop
mediainfo
etckeeper
reflector
ark
xfce4-settings
mesa
mesa-utils
xf86-video-amdgpu
vulkan-mesa-layers
autopep8
tumbler
android-file-transfer
mtpfs
arch-install-scripts
github-cli
dotnet-runtime
dotnet-sdk
android-tools
android-udev
hexyl
libcaca
libsixel
feh
usbutils
carla
iptables-nft
firewalld
cdrtools
iotop
libtool
autoconf
automake
lshw
bluez
bluez-utils
vlc
mpv
socat
stunnel
bind
ncdu
graphicsmagick
imagemagick
speedtest-cli
iproute2
p7zip
dmg2img
make
cmake
gtk3
gtk4
gsettings-desktop-schemas
wl-clipboard
xclip
openssl
pandoc-cli
plocate
clang
ccls
gdb
gcc
gdal
proj
zip
unzip
lzip
tar
alacritty
foot
lf
bridge-utils
cronie
cups
dkms
dnsmasq
docker
docker-buildx
ffmpeg
ffmpegthumbnailer
firefox
flatpak
gallery-dl
geckodriver
gparted
gthumb
guestfs-tools
gvfs
sshfs
jq
tidy
kate
kdeconnect
libvirt
linux-headers
linux-zen
linux-zen-headers
linux-lts
linux-lts-headers
neofetch
neovim
net-tools
networkmanager-openvpn
nm-connection-editor
nodejs-lts-iron
npm
yarn
openbsd-netcat
nmap
openresolv
openssh
openvpn
pavucontrol
piper
pipewire
lib32-pipewire
pipewire-alsa
lib32-alsa-lib
lib32-alsa-plugins
pipewire-audio
pipewire-jack
pipewire-pulse
pamixer
lib32-libpulse
pipewire-v4l2
alsa-firmware
sof-firmware
alsa-ucm-conf
python
python-poetry
python-beautifulsoup4
python-flask
python-flask-cors
python-flask-socketio
python-gbinder
python-matplotlib
python-nodeenv
python-numpy
python-pandas
python-pip
python-pyqt5
python-pyqt6
python-socketio
python-virtualenv
python-websockets
python-dotenv
python-pyopenssl
python-docker
python-validators
python-maxminddb
python-aiodns
python-aiohttp
python-pycryptodome
pyenv
qemu-user-static
qemu-user-static-binfmt
qemu-full
qjackctl
qterminal
sddm
swtpm
thunar
thunar-archive-plugin
veracrypt
virt-manager
virt-viewer
wireshark-qt
xdg-desktop-portal
xdg-desktop-portal-gtk
xorg-xeyes
yt-dlp
edk2-ovmf
jdk-openjdk
jdk17-openjdk
jdk11-openjdk
jdk8-openjdk
ninja
downgrade
wayland-protocols
doxygen
"

if (( HYPRLAND )); then
# swaybg
# swaylock-effects
# polkit-gnome
# rose-pine-hyprcursor
# rose-pine-cursor
# cliphist
packages+="
plasma-systemmonitor
xwaylandvideobridge
polkit-kde-agent
hyprland
hyprwayland-scanner
hyprlang
hyprcursor
hyprutils
wlroots
brightnessctl
dunst
hyprpicker
otf-font-awesome
rofi
hyprlock
hyprpaper
waybar
wf-recorder
wlogout
xdg-desktop-portal-hyprland
awesome
xorg
xorg-xinit
xorg-xclock
xterm
gammastep
nwg-look
grimblast-git
grim
blueberry
"
# Font packages:
packages+="
ttf-nerd-fonts-symbols-common
otf-firamono-nerd
inter-font
otf-sora
ttf-fantasque-nerd
noto-fonts
noto-fonts-emoji
ttf-jetbrains-mono-nerd
ttf-icomoon-feather
ttf-iosevka-nerd
adobe-source-code-pro-fonts
"
# NVIDIA compat packages
if (( NVIDIA && ! INTEL)); then
packages+="
libva-nvidia-driver-git
"
fi
packages+="
qt6-wayland
qt5-wayland
qt5ct
libva
"

# Building Packages
packages+="
libxcb
xcb-proto
xcb-util
xcb-util-keysyms
libxfixes
libx11
libxcomposite
xorg-xinput
libxrender
pixman
cairo
tomlplusplus
doxygen
xmlto
docbook-xsl
"
fi

if (( PLASMA )); then
packages+="
kde-applications
plasma
xorg
"
fi

if (( INTEL_CPU )); then
packages+="
vulkan-intel
"
fi

if (( LAPTOP )); then
packages+="
auto-cpufreq
"
fi

if (( NVIDIA )); then
packages+="
nvidia-dkms
nvidia-settings
nvidia-utils
opencl-nvidia
nvidia-container-toolkit
libva-nvidia-driver
"
fi
if (( NVIDIA && LAPTOP )); then
packages+="
nvidia-prime
"
fi

packages=${packages//$'\n'/ }
packages=$(echo "$packages" | tr -s ' ' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

yay -Syu $packages --needed

echo "Verify that the installation of the packages was successful"
echo "Make sure you have iptables-nft instead of iptables"
echo "If so, run ./04-services.sh"

