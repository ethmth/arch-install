#!/bin/bash

BASE_NAME="stable-diffusion-webui"
NAME=$BASE_NAME
# PYTHON_COMMAND="python3.10"
PYTHON_COMMAND="python"
PORT="7860"

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
    PORT="8860"
fi

git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git $LOC/$NAME

read -p "Input username for webui (will be echoed): " username
read -p "Input password for webui (will be echoed): " password

if [ -e "install-model.sh" ]; then
    sudo cp install-model.sh /usr/bin/install-model
    sudo chmod +rx /usr/bin/install-model
fi

if [ -e "backup-model.sh" ]; then
    sudo cp backup-model.sh /usr/bin/backup-model
    sudo chmod +rx /usr/bin/backup-model
fi

if (( AMD_GPU )); then
    cd $LOC/$NAME
    python -m venv venv

    source $LOC/$NAME/venv/bin/activate

    $LOC/$NAME/venv/bin/pip install --upgrade pip wheel

fi


LAST_LINE=$(tail -1 $LOC/$NAME/webui-user.sh)

sed -i '$ d' "$LOC/$NAME/webui-user.sh"

echo "install_dir=\"$LOC\"" >> $LOC/$NAME/webui-user.sh
echo "python_cmd=\"$PYTHON_COMMAND\"" >> $LOC/$NAME/webui-user.sh
if (( AMD_GPU )); then
    echo "export TORCH_COMMAND=\"pip install torch torchvision --extra-index-url https://download.pytorch.org/whl/rocm5.1.1\"" >> $LOC/$NAME/webui-user.sh
    # echo "export CUDA_VISIBLE_DEVICES=-1" >> $LOC/$NAME/webui-user.sh
    echo "export COMMANDLINE_ARGS=\"--listen --port $PORT --gradio-auth $username:$password --allow-code --enable-insecure-extension-access --api --api-auth $username:$password --upcast-sampling --skip-torch-cuda-test\"" >> $LOC/$NAME/webui-user.sh
else
    echo "export CUDA_VISIBLE_DEVICES=0" >> $LOC/$NAME/webui-user.sh
    echo "export COMMANDLINE_ARGS=\"--listen --port $PORT --gradio-auth $username:$password --allow-code --enable-insecure-extension-access --api --api-auth $username:$password --no-half --no-half-vae --xformers --medvram\"" >> $LOC/$NAME/webui-user.sh
fi
echo "$LAST_LINE" >> $LOC/$NAME/webui-user.sh



cd $LOC/$NAME
bash ./webui.sh

echo "Installation complete. Install models into"
echo "$LOC/$NAME/models"
