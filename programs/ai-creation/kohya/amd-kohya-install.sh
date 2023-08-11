#!/bin/bash

NAME="kohya-amd"
PYTHON_COMMAND="python3.10"

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

DISK=$LOC
LOC="$LOC/programs"
mkdir -p $LOC

git clone https://github.com/bmaltais/kohya_ss.git $LOC/$NAME

cd $LOC/$NAME

$PYTHON_COMMAND -m venv venv
source $LOC/$NAME/venv/bin/activate
$LOC/$NAME/venv/bin/pip install torch==1.13.1+rocm5.2 torchvision==0.14.1+rocm5.2 torchaudio==0.13.1 --extra-index-url https://download.pytorch.org/whl/rocm5.2
$LOC/$NAME/venv/bin/pip install --use-pep517 --upgrade -r requirements.txt

echo "Select fp16"
accelerate config

$LOC/$NAME/venv/bin/pip uninstall tensorflow
$LOC/$NAME/venv/bin/pip install tensorflow-rocm

read -p "Input username for webui (will be echoed): " username
read -p "Input password for webui (will be echoed): " password

echo "#!/bin/bash" > $LOC/$NAME/run.sh
echo "source $LOC/$NAME/venv/bin/activate" >> $LOC/$NAME/run.sh
echo "$LOC/$NAME/venv/bin/python $LOC/$NAME/kohya_gui.py --headless --listen 0.0.0.0 --username $username --password $password" >> $LOC/$NAME/run.sh
chmod +rx $LOC/$NAME/run.sh