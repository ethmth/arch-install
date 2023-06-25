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

DISK=$LOC
LOC="$LOC/programs"
mkdir -p $LOC

git clone https://github.com/bmaltais/kohya_ss.git $LOC/kohya_ss

cd $LOC/kohya_ss

read -p "Input username for webui (will be echoed): " username
read -p "Input password for webui (will be echoed): " password

sed -i "s/127.0.0.1:7860/0.0.0.0:7861/g" docker-compose.yaml
sed -i "s|CLI_ARGS: \"\"|CLI_ARGS: \"--headless --listen 0.0.0.0 --username $username --password $password\"|g" docker-compose.yaml

echo "#!/bin/bash" > $LOC/kohya_ss/run.sh
echo "docker compose --project-directory=$LOC/kohya_ss run --service-ports kohya-ss-gui" >> $LOC/kohya_ss/run.sh
chmod +x $LOC/kohya_ss/run.sh

file_path="docker-compose.yaml" 
temp_file="docker-compose.temp"

mkdir -p $DISK/sd
chmod -R o+rwx $DISK/sd

while IFS= read -r line; do
    line_without_cr=$(echo "$line" | tr -d '\r')
    echo "$line_without_cr" >> "$temp_file"

    if [[ $line == *"volumes"* ]]; then
        echo "      - $DISK/sd:/sd" >> "$temp_file"
        if [ -d "$LOC/stable-diffusion-webui/models" ]; then
            chmod -R o+rwx $LOC/stable-diffusion-webui/models
            echo "      - $LOC/stable-diffusion-webui/models:/models" >> "$temp_file"
        fi
    fi
done < "$file_path"

mv "$temp_file" "$file_path"

docker compose build

echo "Docker version installed."
echo "Run ./run.sh to start. Place files in $DISK/sd"
