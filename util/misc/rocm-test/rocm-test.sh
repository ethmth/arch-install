#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
        echo "This script should not be run with root/sudo privileges."
        exit 1
fi

CUR_USER=$(whoami)
DIR="/home/$CUR_USER/arch-install/util/misc/rocm-test"

if ! [ -d "$DIR" ]; then
    echo "Directory $DIR does not exist."
    exit 1
fi

python -m venv $DIR/.venv
source $DIR/.venv/bin/activate
$DIR/.venv/bin/pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/rocm6.0

$DIR/.venv/bin/python $DIR/devices.py