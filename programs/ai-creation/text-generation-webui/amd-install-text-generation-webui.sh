#!/bin/bash

# https://rentry.org/eq3hg#gptq-for-llama

NAME="text-generation-webui-amd"
PYTHON_COMMAND="python3.10"

if ! [[ $EUID -ne 0 ]]; then
        echo "This script should not be run with root/sudo privileges."
        exit 1
fi

CUR_USER=$(whoami)

if ! [ -e "env.conf" ]; then
	echo "Make sure you run this script in the same directory as env.conf"
	exit 1
fi

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

git clone https://github.com/oobabooga/text-generation-webui.git $LOC/$NAME

cd $LOC/$NAME

# git checkout v1.5

$PYTHON_COMMAND -m venv venv

source $LOC/$NAME/venv/bin/activate

$LOC/$NAME/venv/bin/pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/rocm5.4.2

git clone https://github.com/agrocylo/bitsandbytes-rocm.git
cd bitsandbytes-rocm
make hip
$LOC/$NAME/venv/bin/python setup.py install

cd $LOC/$NAME

# git clone https://github.com/WapaMario63/GPTQ-for-LLaMa-ROCm.git $LOC/$NAME/GPTQ-for-LLaMa
# cd $LOC/$NAME/GPTQ-for-LLaMa
# $LOC/$NAME/venv/bin/python setup_rocm.py install

$LOC/$NAME/venv/bin/pip install -r requirements.txt

echo "#!/bin/bash" > $LOC/$NAME/run.sh
echo "source $LOC/$NAME/venv/bin/activate" >> $LOC/$NAME/run.sh
echo "$LOC/$NAME/venv/bin/python $LOC/$NAME/server.py" >> $LOC/$NAME/run.sh
chmod +rx $LOC/$NAME/run.sh

echo "$NAME installed to $LOC"
echo "cd $LOC/$NAME"
