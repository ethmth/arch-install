#!/bin/bash

NAME="fooocus"
PYTHON_COMMAND="python"

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

git clone https://github.com/lllyasviel/Fooocus.git $LOC/$NAME
cd $LOC/$NAME

$PYTHON_COMMAND -m venv fooocus_env

source $LOC/$NAME/fooocus_env/bin/activate
$LOC/$NAME/fooocus_env/bin/pip install -r requirements_versions.txt

if (( AMD_GPU )); then
$LOC/$NAME/fooocus_env/bin/pip uninstall torch torchvision torchaudio torchtext functorch xformers 
$LOC/$NAME/fooocus_env/bin/pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/rocm5.6
fi

echo "#!/bin/bash" > $LOC/$NAME/run.sh
echo "source $LOC/$NAME/fooocus_env/bin/activate" >> $LOC/$NAME/run.sh
echo "$LOC/$NAME/fooocus_env/bin/python $LOC/$NAME/entry_with_update.py --listen 0.0.0.0" >> $LOC/$NAME/run.sh
chmod +rx $LOC/$NAME/run.sh