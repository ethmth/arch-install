#!/bin/bash

NAME="ComfyUI"

if ! [[ $EUID -ne 0 ]]; then
        echo "This script should not be run with root/sudo privileges."
        exit 1
fi

CUR_USER=$(whoami)

mkdir -p /home/$CUR_USER/programs/$NAME

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

git clone https://github.com/comfyanonymous/ComfyUI.git $LOC/$NAME
cd $LOC/$NAME

python -m venv .venv

source $LOC/$NAME/.venv/bin/activate

$LOC/$NAME/.venv/bin/pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu118 xformers
$LOC/$NAME/.venv/bin/pip install -r requirements.txt

echo "#!/bin/bash" > $LOC/$NAME/run.sh
echo "source $LOC/$NAME/.venv/bin/activate" >> $LOC/$NAME/run.sh
echo "$LOC/$NAME/.venv/bin/python $LOC/$NAME/main.py --listen 0.0.0.0 --port 8188 --enable-cors-header '*' --normalvram" >> $LOC/$NAME/run.sh
chmod +rx $LOC/$NAME/run.sh