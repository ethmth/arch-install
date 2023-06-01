#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi

CUR_USER=$(whoami)
source /home/$CUR_USER/arch-install/config/system.conf

packages="
openssl
pandoc-cli
plocate
gcc-fortran
gdal
proj
unzip
tar
alacritty
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
jq
kate
kdeconnect
libvirt
linux-headers
linux-zen
linux-zen-headers
neofetch
neovim
net-tools
networkmanager-openvpn
nodejs-lts-hydrogen
npm
openbsd-netcat
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
qemu-arch-extra
qemu-desktop
qjackctl
qterminal
sddm-git
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
yt-dlp
edk2-ovmf
jdk-openjdk
jdk17-openjdk
jdk8-openjdk
"

if (( HYPRLAND && AMD )); then
packages+="
hyprland-git
"
fi
if (( HYPRLAND && NVIDIA )); then
packages+="
hyprland-nvidia-git
"
fi
if (( HYPRLAND )); then
packages+="
brightnessctl
dunst
grimblast-git
hyprpicker-git
otf-font-awesome
polkit-gnome
rofi
swaybg
swaylock-effects
waybar-hyprland
wf-recorder
wl-clipboard
wlogout
xdg-desktop-portal-hyprland-git
xorg
"
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


packages=${packages//$'\n'/ }
packages=$(echo "$packages" | tr -s ' ' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

yay -Syu $packages --needed

echo "Verify that the installation of the packages was successful"
echo "NOTE: sddm-git may not install due to being in conflict with sddm"
echo "Run yay -S sddm-git to be sure it's installed"
echo "If so, run ./04-services.sh"

