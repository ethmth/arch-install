#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi

CUR_USER=$(whoami)
source /home/$CUR_USER/arch-install/config/system.conf

# eddie-ui
# bluez-hciconfig
packages="
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
podman
podman-compose
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
openssl
pandoc-cli
plocate
gcc-fortran
gdal
proj
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
docker-compose
ffmpeg
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
nodejs-lts-hydrogen
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
pipewire-alsa
pipewire-audio
pipewire-jack
pipewire-pulse
pipewire-v4l2
python
python-poetry
python-beautifulsoup4
python-flask
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
pyenv
qemu-full
qjackctl
qterminal
sddm
swtpm
thunar
thunar-archive-plugin
veracrypt
virt-manager
virtualbox
virtualbox-host-dkms
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
"

if (( HYPRLAND )); then
#waybar-hyprland
packages+="
brightnessctl
dunst
hyprpicker
otf-font-awesome
polkit-gnome
rofi
swaybg
swaylock-effects
waybar-hyprland
wf-recorder
wlogout
xdg-desktop-portal-hyprland
xorg
gammastep
nwg-look-bin
grimblast-git
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
ttf-comfortaa
ttf-jetbrains-mono-nerd
ttf-icomoon-feather
ttf-iosevka-nerd
adobe-source-code-pro-fonts
"
if (( NVIDIA && ! INTEL )); then
packages+="
hyprland-nvidia-git
"
else
packages+="
hyprland
"
fi
fi

if (( PLASMA )); then
packages+="
kde-applications
plasma
plasma-wayland-session
xorg
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
nvidia-container-runtime
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

