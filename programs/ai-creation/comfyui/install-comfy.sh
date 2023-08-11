#!/bin/bash

NAME="ComfyUI"
PYTHON_COMMAND="python3.10"

if ! [[ $EUID -ne 0 ]]; then
        echo "This script should not be run with root/sudo privileges."
        exit 1
fi

CUR_USER=$(whoami)

for file in $FILES; do
    if ! [ -e "../$NAME/$file" ]; then
            echo "$file doesn't exist. Make sure you run this script in the same directory as ../$NAME/$file"
            exit 1
    fi
done

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

AMD_GPU=0
read -p "Do you want to use an AMD GPU (y/N)? " userInput

if ([ "$userInput" == "y" ] || [ "$userInput" == "Y" ]); then
    AMD_GPU=1
fi

if (( AMD_GPU )); then
    NAME="$NAME-amd"
fi

EXTERNAL_MODELS=0
read -p "Do you want to use an external models folder (y/N)? " userInput

if ([ "$userInput" == "y" ] || [ "$userInput" == "Y" ]); then
    EXTERNAL_MODELS=1
fi

models_dir=""
if (( EXTERNAL_MODELS )); then

    read -p "Please enter the models directory (ending in 'stable-diffusion-webui/'):" models_dir

    if [ "$models_dir" == "" ]; then
        echo "No models directory selected."
        exit 1
    fi

    if ! [ -d "$models_dir" ]; then
        echo "$models_dir is not a valid directory."
        exit 1
    fi
fi

git clone https://github.com/comfyanonymous/ComfyUI.git $LOC/$NAME
cd $LOC/$NAME

if (( EXTERNAL_MODELS )); then
    cp $LOC/$NAME/extra_model_paths.yaml.example $LOC/$NAME/extra_model_paths.yaml
    sed -i "s|path/to/stable-diffusion-webui/|$models_dir|g" $LOC/$NAME/extra_model_paths.yaml
fi

$PYTHON_COMMAND -m venv .venv

source $LOC/$NAME/.venv/bin/activate

if (( AMD_GPU )); then
$LOC/$NAME/.venv/bin/pip install torch==1.13.1+rocm5.2 torchvision==0.14.1+rocm5.2 torchaudio==0.13.1 --extra-index-url https://download.pytorch.org/whl/rocm5.2
else
$LOC/$NAME/.venv/bin/pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu118 xformers
fi
$LOC/$NAME/.venv/bin/pip install -r requirements.txt

echo "#!/bin/bash" > $LOC/$NAME/run.sh
echo "source $LOC/$NAME/.venv/bin/activate" >> $LOC/$NAME/run.sh
if (( AMD_GPU )); then
echo "$LOC/$NAME/.venv/bin/python $LOC/$NAME/main.py --listen 0.0.0.0 --port 8189 --enable-cors-header '*'" >> $LOC/$NAME/run.sh
else
echo "$LOC/$NAME/.venv/bin/python $LOC/$NAME/main.py --listen 0.0.0.0 --port 8188 --enable-cors-header '*' --normalvram" >> $LOC/$NAME/run.sh
fi
chmod +rx $LOC/$NAME/run.sh