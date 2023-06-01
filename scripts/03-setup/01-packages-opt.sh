#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi

CUR_USER=$(whoami)
source /home/$CUR_USER/arch-install/config/system.conf

packages="
cryptomator-bin
android-sdk
scrcpy
anaconda
prismlauncher-git
jdk-openjdk
emacs29-git
texlive-bin
texlive-bibtexextra
biber
perl-file-homedir
perl-yaml-tiny
hashcat-git
steam-devices
vscodium-bin
gcc-fortran
xpadneo-dkms
"

if (( NVIDIA )); then
packages+="
lib32-nvidia-utils
nvidia-dkms
nvidia-settings
nvidia-utils
opencl-nvidia
"
fi
if ! (( AMD )); then
packages+="
obs-studio
v4l2loopback-dkms
"
fi

if (( AMD )); then 
packages+="
amf-amdgpu-pro
lib32-vulkan-amdgpu-pro
obs-streamfx-git
obs-studio-amf
obs-vaapi
obs-vkcapture-git
rocm-opencl-runtime
v4l2loopback-dkms
vulkan-amdgpu-pro
prismlauncher-bin
"
fi

packages=${packages//$'\n'/ }
packages=$(echo "$packages" | tr -s ' ' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

yay -Syu $packages --needed --noconfirm

echo "Verify that the installation of the packages was successful"
echo "If so, run ./02-flatpaks.sh"

if (( NVIDIA )); then
echo "If you're using an NVIDIA GPU as your main GPU (meaning displays plugged in), further action is needed."
echo "Read https://wiki.archlinux.org/title/NVIDIA section 1."
echo "You may need to remove kms from the HOOKS array in /etc/mkinitcpio.conf and regenerate the initramfs to prevent the nouveau model from being loaded."
fi
