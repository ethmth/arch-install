#!/bin/bash

BASE_NAME="vlad-diffusion"
NAME=$BASE_NAME
PYTHON_COMMAND="python3.10"
PORT="7861"

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
    PORT="8861"
fi

git clone https://github.com/vladmandic/automatic.git $LOC/$NAME

echo "#!/bin/bash" > $LOC/$NAME/webui-user.sh
echo "python_cmd=\"$PYTHON_COMMAND\"" >> $LOC/$NAME/webui-user.sh

if (( AMD_GPU )); then
echo "export TORCH_COMMAND=\"pip install torch==1.13.1+rocm5.2 torchvision==0.14.1+rocm5.2 torchaudio==0.13.1 --extra-index-url https://download.pytorch.org/whl/rocm5.2\"" >> $LOC/$NAME/webui-user.sh
echo "export COMMANDLINE_ARGS=\"--use-rocm --listen --port $PORT --auth $username:$password --allow-code\"" >> $LOC/$NAME/webui-user.sh
else
echo "export COMMANDLINE_ARGS=\"--listen --port $PORT --auth $username:$password --allow-code\"" >> $LOC/$NAME/webui-user.sh
fi