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
gpu=$(printf "Intel Integrated Graphics\nAMD\nNvidia\n" | fzf --prompt="Select your host GPU")
de=$(printf "KDE Plasma\nHyprland\n" | fzf --prompt="Select your preferred Desktop Environment")

NVIDIA=0
AMD=0
INTEL=0
HYPRLAND=0
PLASMA=0
LAPTOP=0
DESKTOP=0
if [ "$gpu" == "Nvidia" ]; then
    NVIDIA=1
elif [ "$gpu" == "AMD" ]; then
    AMD=1
else
    INTEL=1
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
cups
dkms
linux-headers
linux-zen
linux-zen-headers
cronie
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
biber
perl-file-homedir
perl-yaml-tiny
libvirt
virt-manager
qemu-arch-extra
dnsmasq
bridge-utils
virtualbox
virtualbox-host-dkms
wireshark-qt
openssh
xdg-desktop-portal
xdg-desktop-portal-gtk
thunar
thunar-archive-plugin
ffmpeg
neovim
pipewire
pipewire-alsa
pipewire-audio
pipewire-jack
pipewire-pulse
pipewire-v4l2
pavucontrol
qjackctl
hashcat-git
"
#base_packages=${base_packages//$'\n'/ }

packages="$base_packages
sddm-git"

#echo "$packages"
#exit 0

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
xorg
hyprpicker-git
polkit-gnome
xdg-desktop-portal-hyprland-git
rofi
wl-clipboard
wf-recorder
swaybg
grimblast-git
waybar-hyprland
wlogout
swaylock-effects
alacritty
otf-font-awesome
dunst
brightnessctl
"
fi

if (( PLASMA )); then
packages+="
xorg
plasma
plasma-wayland-session
kde-applications
qterminal
"
fi

if (( NVIDIA )); then
packages+="
nvidia-dkms
nvidia-settings
nvidia-utils
opencl-nvidia
obs-studio
v4l2loopback-dkms
"
fi

if (( AMD )); then 
packages+="
rocm-opencl-runtime
lib32-vulkan-amdgpu-pro
vulkan-amdgpu-pro
amf-amdgpu-pro
obs-studio-amf
obs-vkcapture-git
obs-streamfx-git
obs-vaapi
v4l2loopback-dkms
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

# Add user to groups
USER=$(whoami)
sudo -k usermod -aG network,libvirt,kvm,input,docker,vboxusers,transmission,wireshark,autologin $USER

# Software Specific Configuration
# sudo sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config

# Enable Services
sudo systemctl enable sddm.service
sudo systemctl enable libvirtd
sudo systemctl enable cronie
sudo systemctl enable docker
sudo systemctl enable sshd
sudo systemctl enable cups
if (( LAPTOP )); then
    sudo systemctl enable auto-cpufreq
fi