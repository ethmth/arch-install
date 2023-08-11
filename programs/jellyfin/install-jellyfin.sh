#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
        echo "This script should not be run with root/sudo privileges."
        exit 1
fi

if ! [ -e "../jellyfin/docker-compose.yml" ]; then
	echo "Make sure you run this script in the same directory as ../jellyfin/docker-compose.yml"
	exit 1
fi

CUR_USER=$(whoami)

GROUP_ID=$(id -g)
USER_ID=$(id -u)

VIDEO_ID=$(getent group video | awk -F: '{for(i=1; i<=NF; i++) if($i ~ /^[0-9]+$/) print $i}')
RENDER_ID=$(getent group render | awk -F: '{for(i=1; i<=NF; i++) if($i ~ /^[0-9]+$/) print $i}')


LOC=$(lsblk --noheadings -o MOUNTPOINTS | grep -v '^$' | grep -v "/boot" | fzf --prompt="Select your desired Jellyfin installation location")

if ([ "$LOC" == "" ] || [ "$LOC" == "Cancel" ]); then
    echo "Nothing was selected"
    echo "Run this script again with target drive mounted."
    exit 1
fi

if [ "$LOC" == "/" ]; then
    LOC="/home/$CUR_USER"
fi

if ! [ -d "$LOC" ]; then
    echo "Your location is not available. Is the disk mounted? Do you have access?"
	exit 1
fi

LOC="$LOC/Jellyfin"

VIDEO_DEVICES=$(
shopt -s nullglob
for g in $(find /sys/kernel/iommu_groups/* -maxdepth 0 -type d | sort -V); do
    echo "IOMMU Group ${g##*/}:"
    for d in $g/devices/*; do
        echo -e "\t$(lspci -nns ${d##*/})"
    done;
done;
)

VIDEO_DEVICES=$(echo "$VIDEO_DEVICES" | grep "VGA")

VIDEO_NAMES=$(echo "$VIDEO_DEVICES" | awk -F ":" '{print $3}' | awk '{$NF=""; print $0}')

selected_device=$(echo "$VIDEO_NAMES" | fzf --prompt="Select the video device to use. Select none for no GPU Acceleration")

GPU_ACCEL=1
NVIDIA=0
if [ "$selected_device" == "" ]; then
    echo "No device selected, proceeding without GPU Acceleration"
    GPU_ACCEL=0
fi

DEVICE="Nothing"
if (( GPU_ACCEL )); then
    NVIDIA=$(echo "$selected_device" | grep "NVIDIA" | wc -l)

    pci_value=$(echo "$VIDEO_DEVICES" | grep -F "$selected_device")
    pci_value=$(echo "$pci_value" | cut -d ' ' -f 1)
    pci_value="${pci_value#"${pci_value%%[![:space:]]*}"}"
    pci_value="${pci_value%"${pci_value##*[![:space:]]}"}"

    DEVICE="/dev/dri/by-path/pci-0000:$pci_value-render"
    if ! [ -e "$DEVICE" ]; then
        echo "The selected device doesn't exist. Exiting."
        exit 1
    fi
fi

mkdir -p $LOC

mkdir -p $LOC/config
mkdir -p $LOC/cache
mkdir -p $LOC/media
chmod -R 777 $LOC/config
chmod -R 777 $LOC/cache
chmod -R 777 $LOC/media

cp docker-compose.yml $LOC/docker-compose.yml

sed -i "s/USER_ID_HERE/$USER_ID/g" $LOC/docker-compose.yml
sed -i "s/GROUP_ID_HERE/$GROUP_ID/g" $LOC/docker-compose.yml
sed -i "s/RENDER_ID_HERE/$RENDER_ID/g" $LOC/docker-compose.yml
sed -i "s/VIDEO_ID_HERE/$VIDEO_ID/g" $LOC/docker-compose.yml


if (( GPU_ACCEL )); then
string_to_echo=""
if (( NVIDIA )); then
string_to_echo=$(echo "    runtime: nvidia
    deploy:
      resources:
        reservations:
          devices:
            - capabilities: [gpu]")
else
string_to_echo=$(echo "    environment:
      - ROC_ENABLE_PRE_VEGA=1  
    devices:
      - $DEVICE:/dev/dri/renderD128")
fi
echo "$string_to_echo" >> $LOC/docker-compose.yml
fi

sudo cp jellyfin /usr/bin/jellyfin
sudo chmod +rx /usr/bin/jellyfin
sudo sed -i "s|PROJECT_DIRECTORY_HERE|$LOC|g" /usr/bin/jellyfin
sudo cp pirokit /usr/bin/pirokit
sudo chmod +rx /usr/bin/pirokit
sudo sed -i "s|PROJECT_DIRECTORY_HERE|$LOC|g" /usr/bin/pirokit

echo "jellyfin installed to /usr/bin. Run jellyfin to start"
echo "Jellyfin will run on port 8096"
echo "In qbittorrent, set Preferences -> Downloads -> Torrent Content Layout: Don't create subfolder"