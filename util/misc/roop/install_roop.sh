#!/bin/bash

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

# git clone --depth 1 https://github.com/s0md3v/roop.git $LOC/roop
# git clone --depth 1 https://github.com/GosuDRM/nsfw-roop.git $LOC/roop
git clone --depth 1 https://github.com/C0untFloyd/roop-unleashed.git $LOC/roop-unleashed


if [ -e "requirements.pip" ]; then
    cp requirements.pip $LOC/roop-unleashed/requirements.pip
fi

cd $LOC/roop-unleashed

python -m venv .venv

source $LOC/roop-unleashed/.venv/bin/activate

# USE PROVIDED REQUIREMENTS:
# $LOC/roop-unleashed/.venv/bin/pip install -r requirements.txt

# USE MY REQUIREMENTS:
$LOC/roop-unleashed/.venv/bin/pip install -r requirements.pip

echo "#!/bin/bash" > $LOC/roop-unleashed/run.sh
echo "source $LOC/roop-unleashed/.venv/bin/activate" >> $LOC/roop-unleashed/run.sh
echo "$LOC/roop-unleashed/.venv/bin/python run.py --execution-provider cuda" >> $LOC/roop-unleashed/run.sh

echo "#!/bin/bash" > $LOC/roop-unleashed/cpu-run.sh
echo "source $LOC/roop-unleashed/.venv/bin/activate" >> $LOC/roop-unleashed/cpu-run.sh
echo "$LOC/roop-unleashed/.venv/bin/python run.py" >> $LOC/roop-unleashed/cpu-run.sh

chmod +rx $LOC/roop-unleashed/run.sh
chmod +rx $LOC/roop-unleashed/cpu-run.sh

echo "Installed roop-unleashed in $LOC"
echo "Run ./run.sh to start it"
echo "cd $LOC/roop-unleashed"