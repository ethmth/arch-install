#!/bin/bash

# Install yay
cd
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --needed --noconfirm
cd
rm -rf yay

# Install Desktop Environment
typeofcpu=$(printf "Desktop\nLaptop\n" | fzf --prompt="Select your type of computer")
cpu=$(printf "AMD\nIntel\n" | fzf --prompt="Select your CPU")
gpu=$(printf "AMD GPU\nIntel Integrated Graphics\nNvidia GPU\n" | fzf --prompt="Select your host GPU")
de=$(printf "Hyprland\nKDE Plasma\n" | fzf --prompt="Select your preferred Desktop Environment")

DESKTOP=0
LAPTOP=0
AMD_CPU=0
INTEL_CPU=0
AMD=0
INTEL=0
NVIDIA=0
HYPRLAND=0
PLASMA=0
if [ "$typeofcpu" == "Laptop" ]; then
    LAPTOP=1
else
    DESKTOP=1
fi
if [ "$cpu" == "AMD" ]; then
    AMD_CPU=1
else
    INTEL_CPU=1
fi
if [ "$gpu" == "Nvidia GPU" ]; then
    NVIDIA=1
elif [ "$gpu" == "AMD GPU" ]; then
    AMD=1
else
    INTEL=1
fi
if [ "$de" == "Hyprland" ]; then
    HYPRLAND=1
else
    PLASMA=1
fi

USER=$(whoami)
echo "DESKTOP=$DESKTOP" > /home/$USER/install-scripts/values.conf
echo "LAPTOP=$LAPTOP" >> /home/$USER/install-scripts/values.conf
echo "AMD_CPU=$AMD_CPU" >> /home/$USER/install-scripts/values.conf
echo "INTEL_CPU=$INTEL_CPU" >> /home/$USER/install-scripts/values.conf
echo "AMD=$AMD" >> /home/$USER/install-scripts/values.conf
echo "INTEL=$INTEL" >> /home/$USER/install-scripts/values.conf
echo "NVIDIA=$NVIDIA" >> /home/$USER/install-scripts/values.conf
echo "HYPRLAND=$HYPRLAND" >> /home/$USER/install-scripts/values.conf
echo "PLASMA=$PLASMA" >> /home/$USER/install-scripts/values.conf

packages="
sddm-git
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
python
python-beautifulsoup4
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
gallery-dl
yt-dlp
gparted
gthumb
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
prismlauncher-git
"
fi

if (( LAPTOP )); then
packages+="
auto-cpufreq
"
fi

# Fun Packages
packages+="
jdk-openjdk
emacs29-git
texlive-bin
texlive-bibtexextra
biber
perl-file-homedir
perl-yaml-tiny
hashcat-git
neofetch
steam-devices-git
vscodium-bin
gcc-fortran
xpadneo-dkms
"

packages=${packages//$'\n'/ }
packages=$(echo "$packages" | tr -s ' ' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

yay -Syu $packages --needed --noconfirm

# Add user to groups
sudo -k usermod -aG network,libvirt,kvm,input,docker,vboxusers,transmission,wireshark,autologin $USER
