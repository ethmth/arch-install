#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
        echo "This script should not be run with root/sudo privileges."
        exit 1
fi

CUR_USER=$(whoami)

LOC=$(lsblk --noheadings -o MOUNTPOINTS | grep -v '^$' | grep -v "/boot" | fzf --prompt="Select your desired MacOS installation location")

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

LOC="$LOC/vm/osx"
mkdir -p $LOC

read -p "Please input your desired MacOS VM name: " DISK_NAME

if [ -d "$LOC/$DISK_NAME" ]; then
    echo "Folder at $LOC/$DISK_NAME already exists. Please try a new name, or remove it and try again"
    exit 1
fi

LOC="$LOC/$DISK_NAME"
mkdir -p $LOC

cd $LOC
git clone --depth 1 https://github.com/sickcodes/osx-serial-generator.git ./osx-serial-generator
cd osx-serial-generator

CUSTOM_PLIST=https://raw.githubusercontent.com/kholia/OSX-KVM/master/OpenCore/config.plist

MODEL=""
SERIAL=""
BOARD_SERIAL=""
UUID=""
MAC_ADDRESS=""

VALUES_ACCEPTED=0

while ! (( VALUES_ACCEPTED )); do
    tsv_file=$(./generate-unique-machine-values.sh \
        -c 1 \
        --model="iMacPro1,1" | grep "Wrote TSV" | tr ' ' '\n' | grep ".tsv")

    values=$(cat $tsv_file | tr '\t' '\n')

    variables=("MODEL" "SERIAL" "BOARD_SERIAL" "UUID" "MAC_ADDRESS" "WIDTH" "HEIGHT")
    IFS=$'\n' read -r -d '' -a lines <<< "$values"

    for i in "${!lines[@]}"; do
        variable_name="${variables[$i]}"
        variable_value="${lines[$i]}"
        declare "$variable_name=$variable_value"
    done


    printf "Here are the generated values:\n"
    printf "\tMODEL: $MODEL\n"
    printf "\tSERIAL: $SERIAL\n"
    printf "\tBOARD_SERIAL: $BOARD_SERIAL\n"
    printf "\tUUID: $UUID\n"
    printf "\tMAC_ADDRESS: $MAC_ADDRESS\n"
    read -p "Do you accept these values? (Y/n)? " userInput
    if ([ "$userInput" == "n" ] || [ "$userInput" == "N" ]); then
        echo "Generating new values"
    else
        VALUES_ACCEPTED=1
    fi
done


printf "Here are the FINAL values:\n"
printf "\tMODEL: $MODEL\n"
printf "\tSERIAL: $SERIAL\n"
printf "\tBOARD_SERIAL: $BOARD_SERIAL\n"
printf "\tUUID: $UUID\n"
printf "\tMAC_ADDRESS: $MAC_ADDRESS\n"


exit


CUSTOM_PLIST=https://raw.githubusercontent.com/sickcodes/osx-serial-generator/master/config-nopicker-custom.plist

./generate-specific-bootdisk.sh \
    --input-plist-url="${CUSTOM_PLIST}" \
    --model iMacPro1,1 \
    --serial C02TW0WAHX87 \
    --board-serial C027251024NJG36UE \
    --uuid 5CCB366D-9118-4C61-A00A-E5BAF3BED451 \
    --mac-address A8:5C:2C:9A:46:2F \
    --output-bootdisk ./OpenCore-nopicker.qcow2 \
    --width 1920 \
    --height 1080 \
    --kernel-args "-pmap_trace"


exit

# To generate new OpenCore image
./opencore-image-ng.sh --cfg config.plist --img OpenCore.qcow2

# To edit config.plist inside OpenCore Image
EDITOR=vim virt-edit -m /dev/sda1 OpenCore.qcow2 /EFI/OC/config.plist
