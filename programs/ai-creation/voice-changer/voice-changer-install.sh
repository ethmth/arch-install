#!/bin/bash

BASE_NAME="voice-changer"
NAME=$BASE_NAME
PYTHON_COMMAND="python3.10"

if ! [[ $EUID -ne 0 ]]; then
        echo "This script should not be run with root/sudo privileges."
        exit 1
fi

CUR_USER=$(whoami)

LOC=$(lsblk --noheadings -o MOUNTPOINTS | grep -v '^$' | grep -v "/boot" | fzf --prompt="Select your desired SD installation location")

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
    NAME="$NAME-amd"
else
    # TODO: DO THIS
   echo "Not yet implemented"
   exit 1
fi

git clone --depth=1 https://github.com/w-okada/voice-changer.git $LOC/$NAME

cd $LOC/$NAME

$PYTHON_COMMAND -m venv .venv

source $LOC/$NAME/.venv/bin/activate

if (( AMD_GPU )); then
    $LOC/$NAME/.venv/bin/pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/rocm5.7
else
   # TODO: DO THIS
   echo "blah"
fi
$LOC/$NAME/.venv/bin/pip install -r server/requirements.txt
$LOC/$NAME/.venv/bin/pip install fairseq

echo "#!/bin/bash" > $LOC/$NAME/run.sh
echo "source $LOC/$NAME/.venv/bin/activate" >> $LOC/$NAME/run.sh
echo "cd $LOC/$NAME/server" >> $LOC/$NAME/run.sh
echo "$LOC/$NAME/.venv/bin/python $LOC/$NAME/server/MMVCServerSIO.py" >> $LOC/$NAME/run.sh

chmod +rx $LOC/$NAME/run.sh

echo "Installed $NAME in $LOC"
echo "Run ./run.sh to start it"
echo "cd $LOC/$NAME"