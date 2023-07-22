#!/bin/bash


if ! [[ $EUID -ne 0 ]]; then
        echo "This script should not be run with root/sudo privileges."
        exit 1
fi

CUR_USER=$(whoami)

LOC=$(lsblk --noheadings -o MOUNTPOINTS | grep -v '^$' | grep -v "/boot" | fzf --prompt="Select your desired $CONTAINER_NAME installation location")
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

source /opt/anaconda/bin/activate
yes | conda create -n deepfacelab -c main python=3.7 cudnn=7.6.5 cudatoolkit=10.1.243
conda activate deepfacelab

current_env=$(conda env list | grep "*" | cut -d' ' -f1)

echo "Using environment $current_env..."

git clone --depth 1 https://github.com/nagadit/DeepFaceLab_Linux.git $LOC/DeepFaceLab_Linux
cd $LOC/DeepFaceLab_Linux
git clone --depth 1 https://github.com/iperov/DeepFaceLab.git

echo "Using pip version:"
python -m pip --version
python -m pip install -r ./DeepFaceLab/requirements-cuda.txt
yes | conda install tensorflow-gpu==2.4.1

echo "Checking GPU:"
python -c "import tensorflow as tf;print(tf.__version__)"