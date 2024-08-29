#!/bin/bash

MODEL_TO_REPLACE="iMacPro1,1"
SERIAL_TO_REPLACE="C02TM2ZBHX87"
BOARD_SERIAL_TO_REPLACE="C02717306J9JG361M"
UUID_TO_REPLACE="007076A6-F2A2-4461-BBE5-BAD019F8025A"
ROM_TO_REPLACE="m7zhIYfl"

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

source $LOC/values.conf

cd $LOC
cd osx-serial-generator

git clone --depth 1 --recurse-submodules https://github.com/kholia/OSX-KVM.git OSX-KVM
cd OSX-KVM/OpenCore

if ! [ -e "/home/$CUR_USER/arch-install/files/templates/config-before.plist" ]; then
    echo "config-before.plist template doesn't exist in /home/$CUR_USER/arch-install/files/templates/config-before.plist"
    exit 1
fi

cp /home/$CUR_USER/arch-install/files/templates/config-before.plist config.plist

sed -i "s/$MODEL_TO_REPLACE/$MODEL/g" config.plist
sed -i "s/$SERIAL_TO_REPLACE/$SERIAL/g" config.plist
sed -i "s/$BOARD_SERIAL_TO_REPLACE/$BOARD_SERIAL/g" config.plist
sed -i "s/$UUID_TO_REPLACE/$UUID/g" config.plist
sed -i "s/$ROM_TO_REPLACE/$ROM/g" config.plist

rm OpenCore.qcow2
./opencore-image-ng.sh --cfg config.plist --img OpenCore.qcow2

cd $LOC
mv $LOC/osx-serial-generator/OSX-KVM/OpenCore/OpenCore.qcow2 .

cd $LOC/osx-serial-generator/OSX-KVM
git restore OVMF_VARS.fd

echo "OpenCore.qcow2 created at $LOC/OpenCore.qcow2"
echo "To edit/check config.plist inside the OpenCore image, run:"
echo "EDITOR=vim virt-edit -m /dev/sda1 $LOC/OpenCore.qcow2 /EFI/OC/config.plist"

# To edit config.plist inside OpenCore Image
# EDITOR=vim virt-edit -m /dev/sda1 OpenCore.qcow2 /EFI/OC/config.plist
