#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi

CUR_USER=$(whoami)
source /home/$CUR_USER/arch-install/config/system.conf

# issuu-dl
# mp4fpsmod
# google-cloud-cli
# pgmodeler
# web-ext
packages="
qtcreator
asciinema
raylib
inkscape
hugo
megasync-bin
gobuster-bin
godot
siege
wine
wine-gecko
wine-mono
winetricks
catfish
juce-docs
juce
vst3sdk
pro-audio
soundfonts
bear
man-pages
valgrind
unityhub
libicu50
icu70
gconf
mono-msbuild
mono-msbuild-sdkresolver
mono
vmware-workstation
mitmproxy
subversion
ts-node
iperf
iperf3
ipscan-bin
tcpdump
hollywood
cmatrix
motion
postgresql
kcalc
jpegoptim
whois
act
thunderbird
cryptomator-bin
pypy
pypy3
miopen-hip
rocm-hip-sdk
rocm-opencl-sdk
okteta
perl-image-exiftool
certbot
certbot-apache
gifsicle
jupyter-nbconvert
git-lfs
git-extras
qbittorrent
python-tqdm
python-pycocotools
python-opencv
python-opengl
python-openai
python-seaborn
python-scikit-learn
python-systemd
python-pysocks
python-sqlalchemy
python-flask-sqlalchemy
python-psycopg2
python-qtconsole
python-regex
jupyterlab
remmina
rstudio-desktop-bin
scrcpy
anaconda
emacs
texlive-bin
texlive-binextra
texlive-bibtexextra
texlive-latexrecommended
texlive-xetex
texlive-games
texlive-pictures
texlive-mathscience
texlive-latexextra
texlive-fontsextra
texlive-plaingeneric
ttf-liberation
ttf-roboto
pdftk
biber
perl-file-homedir
perl-yaml-tiny
perl-compress-raw-lzma
hashcat
john
steam-devices
vscodium-bin
visual-studio-code-bin
xpadneo-dkms
python310
etcher-bin
flutter
hplip
waydroid
"

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
