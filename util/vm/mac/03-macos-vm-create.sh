#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
        echo "This script should not be run with root/sudo privileges."
        exit 1
fi

CUR_USER=$(whoami)
source /home/$CUR_USER/arch-install/config/last_disk.txt

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

MNT_PTS=$(lsblk --noheadings -o MOUNTPOINTS | grep -v '^$' | grep -v "/boot" | grep -v -x "/")
MNT_ARRAY=()

while IFS= read -r line; do
    MNT_ARRAY+=("$line")
done <<< "$MNT_PTS"
MNT_ARRAY+=("/home/$CUR_USER")
file_array=()

for mnt in "${MNT_ARRAY[@]}"; do
    files=$(ls $mnt/vm/osx 2>/dev/null | grep -v "OSX-KVM")
    for file in $files; do
        file_array+=("$mnt/vm/osx/$file")
    done
done

files_string=$(printf "%s\n" "${file_array[@]}")

VM_FOLDER=$(echo "$files_string" | fzf --prompt="Select your MacOS OpenCore folder. If you've not created one, press ESC and create a serial folder and OpenCore image, then come back")

if ([ "$VM_FOLDER" == "" ] || [ "$VM_FOLDER" == "Nothing" ]); then
    echo "No action taken."
    exit 1
fi

NAME=$(basename "$VM_FOLDER")

read -p "Do you want to use $NAME as the name (N for No, Otherwise Yes)? " userInput
if ([ "$userInput" == "N" ] || [ "$userInput" == "n" ]); then
    read -p "Please enter your desired name: " NAME
fi


OS_DISK="Nothing"
oses=$(ls -1 /home/$CUR_USER/vm/os 2>/dev/null | grep macos)
top_os=$(echo "$oses" | head -n 1)
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

read -p "Do you want to create $NAME on network $NETWORK with disk $DISK (OpenCore $VM_FOLDER/OpenCore.qcow2) (YES for Yes, otherwise No)? " userInput

if ! [ "$userInput" == "YES" ]; then
    echo "Exiting. No damage done."
    exit 1
fi

source $VM_FOLDER/values.conf

VM_UUID=$(uuidgen)

mkdir -p /home/$CUR_USER/vm/templates
cp /home/$CUR_USER/arch-install/files/templates/MacOS-before.xml /home/$CUR_USER/vm/templates/$NAME.xml

RESOURCES_DISK="/home/$CUR_USER/arch-install/files/resources.iso"

sed -i "s/VIRT_NETWORK_HERE/$NETWORK/g" /home/$CUR_USER/vm/templates/$NAME.xml
sed -i "s/VIRT_MAC_ADDRESS_HERE/$MAC_ADDRESS/g" /home/$CUR_USER/vm/templates/$NAME.xml
sed -i "s|VIRT_DISK_HERE|$DISK|g" /home/$CUR_USER/vm/templates/$NAME.xml
sed -i "s|VIRT_OCDIR_HERE|$VM_FOLDER|g" /home/$CUR_USER/vm/templates/$NAME.xml
sed -i "s|VIRT_ISODISK_HERE|$OS_DISK|g" /home/$CUR_USER/vm/templates/$NAME.xml
sed -i "s|VIRT_RESOURCESDISK_HERE|$RESOURCES_DISK|g" /home/$CUR_USER/vm/templates/$NAME.xml
sed -i "s/VIRT_NAME_HERE/$NAME/g" /home/$CUR_USER/vm/templates/$NAME.xml
sed -i "s/VIRT_UUID_HERE/$VM_UUID/g" /home/$CUR_USER/vm/templates/$NAME.xml

sudo virsh -c qemu:///system define /home/$CUR_USER/vm/templates/$NAME.xml

chmod o+x /home/$CUR_USER
chmod o+x /home/$CUR_USER/vm
chmod o+x /home/$CUR_USER/vm/os

cd $VM_FOLDER/osx-serial-generator/OSX-KVM
git restore OVMF_VARS.fd


echo "Virtual machine $NAME defined."
echo "Go through and setup MacOS. First, erase and format the disk using a non-APFS system."
echo "Then, reinstall macOS. It can take a long time. Go through the installation setup."

echo "After the installer runs, if your Mac Disk doesn't show up in OpenCore, keep selecting MacOS Installer until it shows up"
echo "If you keep trying, you should eventually get to the 'Select your Country or Region' page, where you should wait until CPU activity slows down before installing"
# echo "After installing, run everying in 01-setup in the Resources ISO before moving on on the host, installing Voodoo kexts, and passing GPU"

