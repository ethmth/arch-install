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

EXTERNAL_MODELS=0
read -p "Do you want to use an external models folder (y/N)? " userInput

if ([ "$userInput" == "y" ] || [ "$userInput" == "Y" ]); then
    EXTERNAL_MODELS=1
fi

folder_arguments=""
if (( EXTERNAL_MODELS )); then
    models_dir=""

    read -p "Please enter the models directory (ending in 'stable-diffusion-webui/'):" models_dir

    if [ "$models_dir" == "" ]; then
        echo "No models directory selected."
        exit 1
    fi

    if ! [ -d "$models_dir" ]; then
        echo "$models_dir is not a valid directory."
        exit 1
    fi

    folder_arguments="--models-dir ${models_dir}models"
fi

git clone https://github.com/vladmandic/automatic.git $LOC/$NAME

read -p "Input username for webui (will be echoed): " username
read -p "Input password for webui (will be echoed): " password

args_auth="--listen --port $PORT --auth $username:$password"
args_api="--api True --api-auth $username:$password"
args_misc="--backend diffusers --allow-code"

args="$args_auth $args_api $args_misc $folder_arguments"

echo "#!/bin/bash" > $LOC/$NAME/webui-user.sh
echo "python_cmd=\"$PYTHON_COMMAND\"" >> $LOC/$NAME/webui-user.sh

if (( AMD_GPU )); then
echo "export TORCH_COMMAND=\"pip install torch==1.13.1+rocm5.2 torchvision==0.14.1+rocm5.2 torchaudio==0.13.1 --extra-index-url https://download.pytorch.org/whl/rocm5.2\"" >> $LOC/$NAME/webui-user.sh
echo "export COMMANDLINE_ARGS=\"--use-rocm $args\"" >> $LOC/$NAME/webui-user.sh
else
echo "export COMMANDLINE_ARGS=\"--use-cuda --medvram $args\"" >> $LOC/$NAME/webui-user.sh
fi