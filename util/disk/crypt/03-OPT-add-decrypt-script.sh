#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
	echo "This script must be run with root/sudo privileges."
	exit 1
fi

partition=$(echo "$(lsblk --list -f | grep crypto_LUKS | awk '{print $1}')" | fzf --prompt="Please select the crypto_LUKS partition you would like to add to your system.")
if [ "$partition" == "" ]; then
    echo "Nothing selected. Nothing done."
    exit 1
fi
partition="/dev/$partition"


typeofdisk=$(printf "HDD\nSSD\n" | fzf --prompt="Select the type of disk")

SSD=0
HDD=0
if [ "$typeofdisk" == "SSD" ]; then
    SSD=1
else
    HDD=1
fi

read -p "Please the name for the disk: " name

read -p "Are you sure you want to create scripts open-$name and close-$name (YES for yes, otherwise No)? " userInput

if ! [ "$userInput" == "YES" ]; then
    echo "Cancelling. No damage done."
    exit 1
fi

if (( SSD )); then
    options+="--allow-discards"
fi

echo "#!/usr/bin/env bash
if [[ \$EUID -ne 0 ]]; then
    echo "This script must be run with root/sudo privileges."
    exit 1
fi
cryptsetup $options luksOpen $partition $name
" > /usr/local/bin/open-$name
chmod 755 /usr/local/bin/open-$name

echo "#!/usr/bin/env bash
if [[ \$EUID -ne 0 ]]; then
    echo "This script must be run with root/sudo privileges."
    exit 1
fi
cryptsetup luksClose $name
" > /usr/local/bin/close-$name
chmod 755 /usr/local/bin/close-$name

echo "Added close-$name and open-$name to /usr/local/bin."
