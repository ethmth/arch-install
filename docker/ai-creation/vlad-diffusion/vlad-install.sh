#!/bin/bash

BASE_NAME="vlad-diffusion"
NAME=$BASE_NAME
PYTHON_COMMAND="python"
PORT="7860"

if ! [[ $EUID -ne 0 ]]; then
        echo "This script should not be run with root/sudo privileges."
        exit 1
fi

CUR_USER=$(whoami)

LOC=$(lsblk --noheadings -o MOUNTPOINTS | grep -v '^$' | grep -v "/boot" | fzf --prompt="Select your desired $NAME installation location")

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

LOC="$LOC/programs"
mkdir -p $LOC

AMD_GPU=0
read -p "Do you want to use an AMD GPU (y/N)? " userInput

if ([ "$userInput" == "y" ] || [ "$userInput" == "Y" ]); then
    AMD_GPU=1
fi

if (( AMD_GPU )); then
    NAME="$NAME-amd"
    PORT="8860"
fi

git clone https://github.com/vladmandic/automatic.git $LOC/$NAME

if (( AMD_GPU )); then
    echo "#!/bin/bash" > $LOC/$NAME/run.sh
    echo "$LOC/$NAME/webui.sh --use-rocm --debug" >> $LOC/$NAME/run.sh
    chmod +x $LOC/$NAME/run.sh
else
    echo "#!/bin/bash" > $LOC/$NAME/run.sh
    echo "$LOC/$NAME/webui.sh --debug" >> $LOC/$NAME/run.sh
    chmod +x $LOC/$NAME/run.sh
fi

