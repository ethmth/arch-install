#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
        echo "This script should not be run with root/sudo privileges."
        exit 1
fi

CUR_USER=$(whoami)

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

VM_FOLDER=$(echo "$files_string" | fzf --prompt="Select your MacOS folder. If you've not created one, press ESC and run ./01-macos-serial.sh, then come back")

if ([ "$VM_FOLDER" == "" ] || [ "$VM_FOLDER" == "Nothing" ]); then
    echo "No action taken."
    exit 1
fi

LOC=$VM_FOLDER

cd $LOC

mkdir -p voodoo
wget -O voodoo/voodoo.zip https://bitbucket.org/RehabMan/os-x-voodoo-ps2-controller/downloads/RehabMan-Voodoo-2018-1008.zip
cd voodoo
unzip voodoo.zip

cp -R Release/VoodooPS2Controller.kext $LOC/osx-serial-generator/OSX-KVM/OpenCore/EFI/OC/Kexts



cd $LOC

mkdir -p voodooHDA
wget -O voodooHDA/VoodooHDA.zip https://downloads.sourceforge.net/project/voodoohda/VoodooHDA.kext-v301.zip
cd voodooHDA
unzip VoodooHDA.zip

cp -R VoodooHDA.kext $LOC/osx-serial-generator/OSX-KVM/OpenCore/EFI/OC/Kexts

echo "Voodoo and VoodooHDA kexts installed in $LOC/osx-serial-generator/OSX-KVM/OpenCore/EFI/OC/Kexts"
echo "You must regenerate the OpenCore disk by running ./05-macos-opencore-update.sh for changes to take effect."
