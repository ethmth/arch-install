#!/bin/bash

NEW_MODEL="iMacPro1,1"

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
        --model="$NEW_MODEL" | grep "Wrote TSV" | tr ' ' '\n' | grep ".tsv")

    values=$(cat $tsv_file | tr '\t' '\n')

    variables=("MODEL" "SERIAL" "BOARD_SERIAL" "UUID" "MAC_ADDRESS" "WIDTH" "HEIGHT")
    IFS=$'\n' read -r -d '' -a lines <<< "$values"

    for i in "${!lines[@]}"; do
        variable_name="${variables[$i]}"
        variable_value="${lines[$i]}"
        declare "$variable_name=$variable_value"
    done

    MAC_ADDRESS="00:25:4B$MAC_ADDRESS"


    printf "Here are the generated values:\n"
    printf "\tMODEL: $MODEL\n"
    printf "\tSERIAL: $SERIAL\n"
    printf "\tBOARD_SERIAL: $BOARD_SERIAL\n"
    printf "\tUUID: $UUID\n"
    printf "\tMAC_ADDRESS: $MAC_ADDRESS\n"
    echo "Go to https://checkcoverage.apple.com/ to check validity of SERIAL"
    echo "You want a SERIAL that is NOT YET VALIDATED ('Please enter a valid serial number' is GOOD)"
    read -p "Do you accept these values (Y/n)? " userInput
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
echo "IMPORTANT: Be sure to backup/save these values. Then, run ./02-macos-opencore-create.sh"
cat $LOC/values.conf
