#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
        echo "This script should not be run with root/sudo privileges."
        exit 1
fi

CUR_USER=$(whoami)
source /home/$CUR_USER/arch-install/config/last_disk.txt

if [ $# -ne 1 ]; then
	echo "Usage: ./linux-create.sh <mx|ubuntu|ubu-droid|mint|mull-gw|waydroid|win10|mitm>"
	exit 1
fi

NETWORK_SELECT=1

TEMPLATE_STRING=""
SEARCH_STRING="NOISO"
DISK_SEARCH_STRING=""
if [ "$1" == "mx" ]; then
    TEMPLATE_STRING="MX"
    # SEARCH_STRING="MX"
    DISK_SEARCH_STRING="Hotspot"
elif [ "$1" == "ubuntu" ]; then
    TEMPLATE_STRING="Ubuntu"
    # SEARCH_STRING="ubuntu"
    DISK_SEARCH_STRING="Ubuntu"
elif [ "$1" == "ubu-droid" ]; then
    TEMPLATE_STRING="Ubu-droid"
    # SEARCH_STRING="ubuntu"
    DISK_SEARCH_STRING="Android"
elif [ "$1" == "mint" ]; then
    TEMPLATE_STRING="Mint"
    # SEARCH_STRING="linuxmint"
    DISK_SEARCH_STRING="Mint"
elif [ "$1" == "win10" ]; then
    TEMPLATE_STRING="Windows10"
    # SEARCH_STRING="Win10"
    DISK_SEARCH_STRING="Windows"
elif [ "$1" == "waydroid" ]; then
    TEMPLATE_STRING="Waydroid"
    # SEARCH_STRING="Waydroid"
    DISK_SEARCH_STRING="Android"
elif [ "$1" == "mull-gw" ]; then
    TEMPLATE_STRING="Mullvad-Gateway"
    # SEARCH_STRING="linuxmint"
    DISK_SEARCH_STRING="VPN-Gateway"
    NETWORK_SELECT=0
elif [ "$1" == "mitm" ]; then
    TEMPLATE_STRING="MITM"
    # SEARCH_STRING="linuxmint"
    DISK_SEARCH_STRING="MITM"
else 
    echo "Usage: ./linux-create.sh <mx|ubuntu|ubu-droid|mint|mull-gw|waydroid|win10|mitm>"
	exit 1
fi

DISK="Nothing"

MNT_PTS=$(lsblk --noheadings -o MOUNTPOINTS | grep -v '^$' | grep -v "/boot" | grep -v -x "/")
MNT_ARRAY=()

while IFS= read -r line; do
    MNT_ARRAY+=("$line")
done <<< "$MNT_PTS"
MNT_ARRAY+=("/home/$CUR_USER")
file_array=()

for mnt in "${MNT_ARRAY[@]}"; do
    files=$(ls $mnt/vm/disk 2>/dev/null)
    for file in $files; do
        file_array+=("$mnt/vm/disk/$file")
    done
done

files_string=$(printf "%s\n" "${file_array[@]}")

SUGGESTED_DISK=$(echo "$files_string" | grep $DISK_SEARCH_STRING | head -n 1)
if [ "$SUGGESTED_DISK" == "" ]; then
    SUGGESTED_DISK=$LAST_DISK
fi
if ! [ "$SUGGESTED_DISK" == "" ]; then
    read -p "Do you want to use $SUGGESTED_DISK (N for No, Otherwise Yes)? " userInput
    if ! ([ "$userInput" == "N" ] || [ "$userInput" == "n" ]); then
    DISK=$SUGGESTED_DISK
    fi
fi
if ([ "$DISK" == "" ] || [ "$DISK" == "Nothing" ]); then
    DISK=$(echo "$files_string" | fzf --prompt="Select your disk. If you've not created one, press ESC and run ./create-qcow2.sh, then come back")
fi

if ([ "$DISK" == "" ] || [ "$DISK" == "Nothing" ]); then
    echo "No action taken."
    exit 1
fi

echo "LAST_DISK=$DISK" > /home/$CUR_USER/arch-install/config/last_disk.txt


NAME=$(basename "$DISK")
NAME="${NAME%.*}"

read -p "Do you want to use $NAME as the name (N for No, Otherwise Yes)? " userInput
if ([ "$userInput" == "N" ] || [ "$userInput" == "n" ]); then
    read -p "Please enter your desired name: " NAME
fi


OS_DISK="Nothing"
oses=$(ls -1 /home/$CUR_USER/vm/os 2>/dev/null)
top_os=$(echo "$oses" | grep $SEARCH_STRING | head -n 1)
read -p "Do you want to use $top_os as the iso (N for No, Otherwise Yes)? " userInput
if ([ "$userInput" == "N" ] || [ "$userInput" == "n" ]); then
    OS_DISK=$(echo "$oses" | fzf --prompt="Please select the installation iso")
else
    OS_DISK=$top_os
fi

if ([ "$OS_DISK" == "" ] || [ "$OS_DISK" == "Nothing" ]); then
    echo "No OS ISO Disk selected."
    exit 1
fi

OS_DISK="/home/$CUR_USER/vm/os/$OS_DISK"

NETWORK="Default"
if (( NETWORK_SELECT )); then
    networks=$(sudo virsh net-list --all | grep "yes" | awk '{print $1}')
    NETWORK=$(echo "$networks" | fzf --prompt="Select your network")
fi

read -p "Do you want to create $NAME on network $NETWORK with disk $DISK (YES for Yes, otherwise No)? " userInput

if ! [ "$userInput" == "YES" ]; then
    echo "Exiting. No damage done."
    exit 1
fi

MAC=$(hexdump -n 3 -ve '1/1 "%.2x "' /dev/random | awk -v a="2,6,a,e" -v r="$RANDOM" 'BEGIN{srand(r);}NR==1{split(a,b,",");r=int(rand()*4+1);printf "%s%s:%s:%s\n",substr($1,0,1),b[r],$2,$3,$4,$5,$6}')
MAC="52:54:00:$MAC"
MAC2=$(hexdump -n 3 -ve '1/1 "%.2x "' /dev/random | awk -v a="2,6,a,e" -v r="$RANDOM" 'BEGIN{srand(r);}NR==1{split(a,b,",");r=int(rand()*4+1);printf "%s%s:%s:%s\n",substr($1,0,1),b[r],$2,$3,$4,$5,$6}')
MAC2="52:54:00:$MAC2"
UUID=$(uuidgen)

mkdir -p /home/$CUR_USER/vm/templates
cp /home/$CUR_USER/arch-install/files/templates/$TEMPLATE_STRING.xml /home/$CUR_USER/vm/templates/$NAME.xml

RESOURCES_DISK="/home/$CUR_USER/arch-install/files/resources.iso"

SHAREPOINT_BOOL=$(cat /home/$CUR_USER/arch-install/files/templates/$TEMPLATE_STRING.xml | grep "VIRT_SHAREPOINT_HERE" | wc -l)
SHAREPOINT_DISK=$(echo "$DISK" | cut -d'/' -f1-3)

if (( SHAREPOINT_BOOL )); then
    mkdir -p $SHAREPOINT_DISK/vm/share
    sed -i "s|VIRT_SHAREPOINT_HERE|$SHAREPOINT_DISK/vm/share|g" /home/$CUR_USER/vm/templates/$NAME.xml
fi

sed -i "s/VIRT_NETWORK_HERE/$NETWORK/g" /home/$CUR_USER/vm/templates/$NAME.xml
sed -i "s/VIRT_MAC_ADDRESS_HERE/$MAC/g" /home/$CUR_USER/vm/templates/$NAME.xml
sed -i "s/VIRT_MAC_ADDRESS2_HERE/$MAC2/g" /home/$CUR_USER/vm/templates/$NAME.xml
sed -i "s|VIRT_DISK_HERE|$DISK|g" /home/$CUR_USER/vm/templates/$NAME.xml
sed -i "s|VIRT_ISODISK_HERE|$OS_DISK|g" /home/$CUR_USER/vm/templates/$NAME.xml
sed -i "s|VIRT_RESOURCESDISK_HERE|$RESOURCES_DISK|g" /home/$CUR_USER/vm/templates/$NAME.xml
sed -i "s/VIRT_NAME_HERE/$NAME/g" /home/$CUR_USER/vm/templates/$NAME.xml
sed -i "s/VIRT_UUID_HERE/$UUID/g" /home/$CUR_USER/vm/templates/$NAME.xml

sudo virsh -c qemu:///system define /home/$CUR_USER/vm/templates/$NAME.xml

chmod o+x /home/$CUR_USER
chmod o+x /home/$CUR_USER/vm
chmod o+x /home/$CUR_USER/vm/os

echo "Virtual machine $NAME defined."

if [ "$1" == "nix-droid" ]; then
    echo "IMPORTANT: Set the correct OpenGL device in virt-manager"
    echo "Go through the installer with user 'android' and No Desktop"
    echo "Once booted up, run: 'nixos-generate-config'. Then,"
    echo "sudo mkdir -p /mnt/sr0 && sudo mount /dev/sr0 /mnt/sr0 && cd /mnt/sr0/nix-droid"
fi

if [ "$1" == "ubu-droid" ]; then
    echo "IMPORTANT: Set the correct OpenGL device in virt-manager"
    echo "Go through the installer with Minimal Install, and no downloading updates."
    echo "Name your user 'android', and check 'Log in automatically'"
    echo "Once booted up, run the appropriate scripts"
fi

if [ "$1" == "waydroid" ]; then
    echo "Go through the setup without OpenGL in virt-manager"
    echo "Go through the installer with No Swap. If needed, login info is live:evolution"
    echo "Name your user 'android', and check 'Log in automatically'"
	echo "After reboot, enable Spice OpenGL and Virtio 3D acceleration in virt-manager"
    echo "Once booted up, run the appropriate scripts."
fi
