#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
        echo "This script should not be run with root/sudo privileges."
        exit 1
fi

CUR_USER=$(whoami)

LOC=$(lsblk --noheadings -o MOUNTPOINTS | grep -v '^$' | grep -v "/boot" | fzf --prompt="Select your desired kohya installation location")

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

# git clone https://github.com/bmaltais/kohya_ss.git $LOC/kohya_ss

cd $LOC/kohya_ss
# chmod +x ./setup.sh
# ./setup.sh

read -p "Input username for webui (will be echoed): " username
read -p "Input password for webui (will be echoed): " password

sed -i "s/127.0.0.1/0.0.0.0/g" docker-compose.yaml
sed -i "s|CLI_ARGS: \"\"|CLI_ARGS: \"--headless --listen 0.0.0.0 --server_port 7861  --username $username --password $password\"|g" docker-compose.yaml

docker compose build

# echo "#!/bin/bash" > $LOC/kohya_ss/run.sh
# echo "bash $LOC/kohya_ss/gui.sh --headless --listen 0.0.0.0 --server_port 7861  --username $username --password $password" >> $LOC/kohya_ss/run.sh
# chmod +x $LOC/kohya_ss/run.sh

# echo "Now, you will go through the accelerate config setup process"
# echo "Default values are fine. fp16 mixed precision."
# read -p "Press ENTER to continue" userInput

# source venv/bin/activate
# # accelerate config --config_file config_files/accelerate/default_config.yaml
# accelerate config

# echo "Installation complete. To run:"
# echo "bash $LOC/kohya_ss/run.sh"