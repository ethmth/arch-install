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

git clone --depth 1 https://github.com/s0md3v/roop.git $LOC/roop

if [ -e "requirements.pip" ]; then
    cp requirements.pip $LOC/roop/requirements.pip
fi

cd $LOC/roop

python -m venv .venv

source $LOC/roop/.venv/bin/activate

# USE PROVIDED REQUIREMENTS:
# $LOC/roop/.venv/bin/pip install -r requirements.txt

# USE MY REQUIREMENTS:
$LOC/roop/.venv/bin/pip install -r requirements.pip

echo "#!/bin/bash" > $LOC/roop/run.sh
echo "source $LOC/roop/.venv/bin/activate" >> $LOC/roop/run.sh
echo "$LOC/roop/.venv/bin/python $LOC/roop/run.py --execution-provider cuda" >> $LOC/roop/run.sh

echo "#!/bin/bash" > $LOC/roop/roop.sh
echo "source $LOC/roop/.venv/bin/activate" >> $LOC/roop/roop.sh
echo "$LOC/roop/.venv/bin/python $LOC/roop/run.py -s \$1 -t \$2 -o output/\$3.mp4 --keep-frames --keep-fps --execution-provider cuda" >> $LOC/roop/roop.sh

echo "#!/bin/bash" > $LOC/roop/cpu-run.sh
echo "source $LOC/roop/.venv/bin/activate" >> $LOC/roop/cpu-run.sh
echo "$LOC/roop/.venv/bin/python $LOC/roop/run.py" >> $LOC/roop/cpu-run.sh

if grep -q "^MAX_PROBABILITY =" $LOC/roop/roop/predictor.py; then
    sed -i "s|^MAX_PROBABILITY =.*|MAX_PROBABILITY = 9999|" $LOC/roop/roop/predictor.py
fi

chmod +rx $LOC/roop/run.sh
chmod +rx $LOC/roop/cpu-run.sh
chmod +rx $LOC/roop/roop.sh

sudo cp $LOC/roop/roop.sh /usr/bin/roop
sudo chmod +rx /usr/bin/roop

echo "Installed roop in $LOC"
echo "Run ./run.sh to start it"
echo "cd $LOC/roop"