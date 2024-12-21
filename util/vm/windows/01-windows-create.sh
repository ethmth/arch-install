#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
        echo "This script should not be run with root/sudo privileges."
        exit 1
fi

CUR_USER=$(whoami)
if [ -f "/home/$CUR_USER/arch-install/config/last_disk.txt" ]; then
source /home/$CUR_USER/arch-install/config/last_disk.txt
fi

DISK="Nothing"

if ! [ "$LAST_DISK" == "" ]; then
    if [ -e "$LAST_DISK" ]; then
        read -p "Do you want to use $LAST_DISK (N for No, Otherwise Yes)? " userInput
        if ! ([ "$userInput" == "N" ] || [ "$userInput" == "n" ]); then
            DISK=$LAST_DISK
        fi
    fi
fi

if [ "$DISK" == "Nothing" ]; then
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

SEARCH_STRING="NOISO"
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

networks=$(sudo virsh net-list --all | grep "yes" | awk '{print $1}')
NETWORK=$(echo "$networks" | fzf --prompt="Select your network")

read -p "Do you want to create $NAME on network $NETWORK with disk $DISK (YES for Yes, otherwise No)? " userInput

if ! [ "$userInput" == "YES" ]; then
    echo "Exiting. No damage done."
    exit 1
fi

MAC=$(hexdump -n 3 -ve '1/1 "%.2x "' /dev/random | awk -v a="2,6,a,e" -v r="$RANDOM" 'BEGIN{srand(r);}NR==1{split(a,b,",");r=int(rand()*4+1);printf "%s%s:%s:%s\n",substr($1,0,1),b[r],$2,$3,$4,$5,$6}')
MAC="52:54:00:$MAC"
UUID=$(uuidgen)

mkdir -p /home/$CUR_USER/vm/templates
cp /home/$CUR_USER/arch-install/files/templates/Windows-before.xml /home/$CUR_USER/vm/templates/$NAME.xml

RESOURCES_DISK="/home/$CUR_USER/arch-install/files/resources.iso"

sed -i "s/VIRT_NETWORK_HERE/$NETWORK/g" /home/$CUR_USER/vm/templates/$NAME.xml
sed -i "s/VIRT_MAC_ADDRESS_HERE/$MAC/g" /home/$CUR_USER/vm/templates/$NAME.xml
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

echo "REMOVE Either SDA Disk Device or VirtIO Block Device."
echo "If you're using a .qcow2 file, keep the SDA Disk Device."
echo "If you're using a physical disk, keep the VirtIO Block Device."

echo "Add your GPU to the VM, install Chocolatey & packages using resources.iso, and setup Graphics drivers."
echo "Then, run ./02-windows-update.sh to remove Virtual Graphics Devices"
