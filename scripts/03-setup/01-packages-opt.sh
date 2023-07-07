#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi

CUR_USER=$(whoami)
source /home/$CUR_USER/arch-install/config/system.conf

#issuu-dl
packages="
qbittorrent
python-pycocotools
python-opencv
remmina
rstudio-desktop-bin
cryptomator-bin
scrcpy
anaconda
emacs29-git
texlive-bin
texlive-binextra
texlive-bibtexextra
texlive-latexrecommended
pdftk
biber
perl-file-homedir
perl-yaml-tiny
hashcat-git
steam-devices
vscodium-bin
xpadneo-dkms
python310
etcher-bin
flutter
hplip
waydroid
"

if (( NVIDIA )); then
packages+="
cuda
cuda-tools
python-cuda
python-tensorflow-cuda
python-torchvision-cuda
python-pytorch-cuda
"
else
packages+="
python-tensorflow
python-torchvision
python-pytorch
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

yay -Syu $packages --needed

echo "Verify that the installation of the packages was successful"
echo "If so, run ./02-flatpaks.sh"

#if (( NVIDIA )); then
#echo "If you're using an NVIDIA GPU as your main GPU (meaning displays plugged in), further action may be needed."
#echo "Read https://wiki.archlinux.org/title/NVIDIA section 1."
#echo "You may need to remove kms from the HOOKS array in /etc/mkinitcpio.conf and regenerate the initramfs to prevent the nouveau model from being loaded."
#echo "If you're using an NVIDIA GPU alongside your main GPU, you may want to ensure nvidia-prime is installed and ibt=off."
#fi
