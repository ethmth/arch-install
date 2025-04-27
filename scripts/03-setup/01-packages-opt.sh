#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi

CUR_USER=$(whoami)
source /home/$CUR_USER/arch-install/config/system.conf

# issuu-dl
# ocrmypdf
# mp4fpsmod
# pgmodeler
# visual-studio-code-bin
# squid
packages="
liquibase
visual-studio-code-bin
google-cloud-cli
maven
yubikey-manager
yubico-authenticator-bin
terraform
aws-cli
hfsprogs
etcher-bin
caddy
httrack
megasync-bin
pdfgrep
supabase-bin
testdisk
tesseract-data-eng
spyder
gunicorn
cscope
krita
v4l2loopback-dkms
xournalpp
asciinema
raylib
inkscape
hugo
gobuster-bin
godot
siege
catfish
juce-docs
juce
vst3sdk
pro-audio
soundfonts
bear
man-pages
valgrind
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
pypy
pypy3
miopen-hip
rocm-hip-sdk
hipblas
hipblaslt
hiprand
hipsparse
hipcub
rocthrust
rocm-opencl-sdk
okteta
perl-image-exiftool
certbot
certbot-apache
gifsicle
jupyter-nbconvert
jupyter-nbformat
git-lfs
git-extras
qbittorrent
python-google-auth-oauthlib
python-inotify
python-tqdm
python-simple-term-menu
python-jsondiff
python-pycocotools
python-phonenumbers
python-opencv
python-opengl
python-openai
python-seaborn
python-scikit-learn
python-systemd
python-pysocks
python-sqlalchemy
python-flask-sqlalchemy
python-flask-cors
python-psycopg2
python-qtconsole
python-regex
python-libusb1
python-adb-shell
jupyterlab
jupyter-notebook
remmina
scrcpy
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
texlive-luatex
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
xpadneo-dkms
python310
hplip
waydroid
obs-studio
"
#if (( NVIDIA )); then
#packages+="
#python-pytorch-cuda
#cuda
#cudnn
#"
#fi

# if ! (( AMD )); then
# packages+="
# obs-studio
# "
# fi

# if (( AMD )); then 
# packages+="
# amf-amdgpu-pro
# lib32-vulkan-amdgpu-pro
# obs-streamfx-git
# obs-studio-amf
# obs-vaapi
# obs-vkcapture-git
# vulkan-amdgpu-pro
# prismlauncher-bin
# "
# fi

packages=${packages//$'\n'/ }
packages=$(echo "$packages" | tr -s ' ' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

yay -Syu $packages --needed

echo "To setup mega, you may have to login to awesome wm to login."
echo "Verify that the installation of the packages was successful"
echo "If so, run ./02-flatpaks.sh"

#if (( NVIDIA )); then
#echo "If you're using an NVIDIA GPU as your main GPU (meaning displays plugged in), further action may be needed."
#echo "Read https://wiki.archlinux.org/title/NVIDIA section 1."
#echo "You may need to remove kms from the HOOKS array in /etc/mkinitcpio.conf and regenerate the initramfs to prevent the nouveau model from being loaded."
#echo "If you're using an NVIDIA GPU alongside your main GPU, you may want to ensure nvidia-prime is installed and ibt=off."
#fi
