#!/bin/bash

# Install yay
#cd
#git clone https://aur.archlinux.org/yay.git
#cd yay
#makepkg -si --needed --noconfirm
#cd
#rm -rf yay

# Install Desktop Environment
typeofcpu=$(printf "Laptop\nDesktop\n" | fzf --prompt="Select your type of computer")
gpu=$(printf "AMD/Intel\nNvidia\n" | fzf --prompt="Select your host GPU")
de=$(printf "KDE Plasma\nHyprland\n" | fzf --prompt="Select your preferred Desktop Environment")

NVIDIA=0
AMD=0
HYPRLAND=0
PLASMA=0
LAPTOP=0
DESKTOP=0
if [ "$gpu" == "Nvidia" ]; then
    NVIDIA=1
else
    AMD=1
fi
if [ "$de" == "Hyprland" ]; then
    HYPRLAND=1
else
    PLASMA=1
fi
if [ "$typeofcpu" == "Laptop" ]; then
    LAPTOP=1
else
    DESKTOP=1
fi

base_packages="
dkms
linux-headers
linux-zen
linux-zen-headers
openresolv
openvpn
networkmanager-openvpn
openbsd-netcat
jdk-openjdk
python
python-beautifulsoup4
python-cuda
python-flask
python-flask-socketio
python-gbinder
python-matplotlib
python-nodeenv
python-numpy
python-pandas
python-pip
python-pyqt6
python-pyqt5
python-socketio
python-virtualenv
python-websockets
geckodriver
firefox
flatpak
docker
docker-compose
texlive-bin
texlive-bibtexextra
libvirt
virt-manager
qemu-arch-extra
dnsmasq
bridge-utils
virtualbox
virtualbox-host-dkms
wireshark-qt
"
#base_packages=${base_packages//$'\n'/ }

packages="$base_packages
sddm-git"

#echo "$packages"
#exit 0


if (( HYPRLAND )); then
packages+="
hyprpicker-git
"
fi
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

if (( NVIDIA )); then
packages+="
nvidia-dkms
nvidia-settings
nvidia-utils
opencl-nvidia
"
fi

if (( AMD )); then 
packages+="
obs-studio-amf
obs-vkcapture-git
obs-streamfx-git
obs-vaapi
v4l2loopback-dkms
"
fi

if (( PLASMA )); then
packages+="
xorg
plasma
plasma-wayland-session
kde-applications
"
fi

if (( LAPTOP )); then
packages+="
auto-cpufreq
"
fi

packages=${packages//$'\n'/ }
packages=$(echo "$packages" | tr -s ' ' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

echo "$packages"
exit 0

# Add user to group
USER=$(whoami)
sudo -k usermod -aG network,libvirt,kvm,input,docker,vboxusers,transmission,wireshark,autologin $USER

# Enable Services
sudo systemctl enable sddm.service
sudo systemctl enable libvirtd
if (( LAPTOP )); then
    sudo systemctl enable auto-cpufreq
fi