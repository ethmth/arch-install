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

MODEL=""
SERIAL=""
BOARD_SERIAL=""
UUID=""
MAC_ADDRESS=""
ROM=""

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

ROM="${MAC_ADDRESS//:/}"
ROM="${ROM,,}"

echo "MODEL='$MODEL'" > $LOC/values.conf
echo "SERIAL='$SERIAL'" >> $LOC/values.conf
echo "BOARD_SERIAL='$BOARD_SERIAL'" >> $LOC/values.conf
echo "UUID='$UUID'" >> $LOC/values.conf
echo "MAC_ADDRESS='$MAC_ADDRESS'" >> $LOC/values.conf
echo "ROM='$ROM'" >> $LOC/values.conf

echo "These values have been stored in $LOC/values.conf"
echo "IMPORTANT: Be sure to backup/save these values."
cat $LOC/values.conf

read -p "Press ENTER to continue " userInput


CUSTOM_PLIST=https://raw.githubusercontent.com/kholia/OSX-KVM/master/OpenCore/config.plist
# CUSTOM_PLIST=https://raw.githubusercontent.com/sickcodes/osx-serial-generator/master/config-nopicker-custom.plist

./generate-specific-bootdisk.sh \
    --input-plist-url="${CUSTOM_PLIST}" \
    --model "${MODEL}" \
    --serial "${SERIAL}" \
    --board-serial "${BOARD_SERIAL}" \
    --uuid "${UUID}" \
    --mac-address "${MAC_ADDRESS}" \
    --output-bootdisk ./OpenCore.qcow2 \
    --width 1280 \
    --height 720


exit

# To generate new OpenCore image
./opencore-image-ng.sh --cfg config.plist --img OpenCore.qcow2

# To edit config.plist inside OpenCore Image
EDITOR=vim virt-edit -m /dev/sda1 OpenCore.qcow2 /EFI/OC/config.plist
