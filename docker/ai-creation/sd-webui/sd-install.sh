#!/bin/bash

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

git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git $LOC/stable-diffusion-webui

read -p "Input username for webui (will be echoed): " username
read -p "Input password for webui (will be echoed): " password

LAST_LINE=$(tail -1 $LOC/stable-diffusion-webui/webui-user.sh)

sed -i '$ d' "$LOC/stable-diffusion-webui/webui-user.sh"

echo "install_dir=\"$LOC\"" >> $LOC/stable-diffusion-webui/webui-user.sh
# echo "export TORCH_COMMAND=\"pip install torch==1.12.1+cu113 --extra-index-url https://download.pytorch.org/whl/cu113\"" >> $LOC/stable-diffusion-webui/webui-user.sh
echo "python_cmd=\"python3.10\"" >> $LOC/stable-diffusion-webui/webui-user.sh
echo "export COMMANDLINE_ARGS=\"--listen --gradio-auth $username:$password --allow-code --enable-insecure-extension-access --api --api-auth $username:$password --api-log --no-half --no-half-vae --xformers --medvram\"" >> $LOC/stable-diffusion-webui/webui-user.sh
echo "$LAST_LINE" >> $LOC/stable-diffusion-webui/webui-user.sh


if [ -e "install-model.sh" ]; then
    sudo cp install-model.sh /usr/bin/install-model
    sudo chmod +rx /usr/bin/install-model
fi

if [ -e "backup-model.sh" ]; then
    sudo cp backup-model.sh /usr/bin/backup-model
    sudo chmod +rx /usr/bin/backup-model
fi


cd $LOC/stable-diffusion-webui
bash ./webui.sh

echo "Installation complete. Install models into"
echo "$LOC/stable-diffusion-webui/models"
