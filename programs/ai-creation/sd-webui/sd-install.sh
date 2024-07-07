#!/bin/bash

BASE_NAME="stable-diffusion-webui"
NAME=$BASE_NAME
PYTHON_COMMAND="python3.10"
PORT="7861"

if ! [[ $EUID -ne 0 ]]; then
        echo "This script should not be run with root/sudo privileges."
        exit 1
fi

CUR_USER=$(whoami)

LOC=$(lsblk --noheadings -o MOUNTPOINTS | grep -v '^$' | grep -v "/boot" | fzf --prompt="Select your desired SD installation location")

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

    folder_arguments="--ckpt-dir ${models_dir}models/Stable-diffusion --codeformer-models-path ${models_dir}models/Codeformer --gfpgan-models-path ${models_dir}models/GFPGAN --esrgan-models-path ${models_dir}models/ESRGAN"
fi



git clone https://github.com/lllyasviel/stable-diffusion-webui-forge.git $LOC/$NAME

read -p "Input username for webui (will be echoed): " username
read -p "Input password for webui (will be echoed): " password

# if [ -e "install-model.sh" ]; then
#     sudo cp install-model.sh /usr/bin/install-model
#     sudo chmod +rx /usr/bin/install-model
# fi

# if [ -e "backup-model.sh" ]; then
#     sudo cp backup-model.sh /usr/bin/backup-model
#     sudo chmod +rx /usr/bin/backup-model
# fi

LAST_LINE=$(tail -1 $LOC/$NAME/webui-user.sh)

sed -i '$ d' "$LOC/$NAME/webui-user.sh"

echo "python_cmd=\"$PYTHON_COMMAND\"" >> $LOC/$NAME/webui-user.sh
echo "install_dir=\"$LOC\"" >> $LOC/$NAME/webui-user.sh
if (( AMD_GPU )); then
    # echo "export TORCH_COMMAND=\"pip install torch==2.0.1+rocm5.4.2 torchvision==0.15.2+rocm5.4.2 --index-url https://download.pytorch.org/whl/rocm5.4.2\"" >> $LOC/$NAME/webui-user.sh
    # echo "export TORCH_COMMAND=\"pip install torch==2.3.0+rocm6.0 torchvision==0.18.0+rocm6.0 torchaudio==2.3.0+rocm6.0 --index-url https://download.pytorch.org/whl/rocm6.0\"" >> $LOC/$NAME/webui-user.sh
    # echo "export TORCH_COMMAND=\"pip install torch==1.13.1+rocm5.2 torchvision==0.14.1+rocm5.2 torchaudio==0.13.1 --extra-index-url https://download.pytorch.org/whl/rocm5.2\"" >> $LOC/$NAME/webui-user.sh
    echo "export TORCH_COMMAND=\"pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/rocm6.0\"" >> $LOC/$NAME/webui-user.sh
    echo "export COMMANDLINE_ARGS=\"--listen --port $PORT --gradio-auth $username:$password --allow-code --enable-insecure-extension-access --api --api-auth $username:$password $folder_arguments\"" >> $LOC/$NAME/webui-user.sh
else
    echo "export COMMANDLINE_ARGS=\"--listen --port $PORT --gradio-auth $username:$password --allow-code --enable-insecure-extension-access --api --api-auth $username:$password $folder_arguments\"" >> $LOC/$NAME/webui-user.sh
fi
echo "$LAST_LINE" >> $LOC/$NAME/webui-user.sh

# cd $LOC/$NAME
# bash ./webui.sh

echo "Installation complete. Install models into"
echo "$LOC/$NAME/models"
