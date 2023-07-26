#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
        echo "This script should not be run with root/sudo privileges."
        exit 1
fi

CUR_USER=$(whoami)

if ! [ -e "req.txt" ]; then
    echo "req.txt not found."
    exit 1
fi

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
yes | conda create -n talknet python=3.8 
conda activate talknet

current_env=$(conda env list | grep "*" | cut -d' ' -f1)

echo "Using environment $current_env..."

git clone --depth 1 https://github.com/SortAnon/ControllableTalkNet.git $LOC/ControllableTalkNet
cp req.txt $LOC/ControllableTalkNet/req.txt
cd $LOC/ControllableTalkNet
git clone --depth 1 https://github.com/SortAnon/hifi-gan.git

echo "Using pip version:"
python -m pip --version
python -m pip install tensorflow==2.4.1
python -m pip install -r req.txt
yes | conda install -c conda-forge cudatoolkit=11.0 cudnn=8.0
python -m pip install jupyterlab

echo "Checking GPU:"
python -c "import tensorflow as tf;print(tf.__version__)"

echo "#!/bin/bash" > $LOC/ControllableTalkNet/run.sh
echo "source /opt/anaconda/bin/activate" >> $LOC/ControllableTalkNet/run.sh
echo "jupyter-lab --NotebookApp.token='' --NotebookApp.password='' --no-browser --port=8889" >> $LOC/ControllableTalkNet/run.sh

chmod +rx $LOC/ControllableTalkNet/run.sh

echo "Installed to $LOC/ControllableTalkNet"
echo "Run ./run.sh to start"
echo "cd $LOC/ControllableTalkNet"