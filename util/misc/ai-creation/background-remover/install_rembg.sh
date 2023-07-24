#!/bin/bash

NAME="rembg"

if ! [[ $EUID -ne 0 ]]; then
        echo "This script should not be run with root/sudo privileges."
        exit 1
fi

CUR_USER=$(whoami)

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

mkdir -p $LOC/$NAME
cd $LOC/$NAME

python -m venv $LOC/$NAME/.venv

source $LOC/$NAME/.venv/bin/activate

$LOC/$NAME/.venv/bin/pip install rembg[gpu,cli]

echo "#!/bin/bash" > $LOC/$NAME/run.sh
echo "source $LOC/$NAME/.venv/bin/activate" >> $LOC/$NAME/run.sh
# echo "$LOC/$NAME/.venv/bin/python -m rembg i \$1 rembg_$1" >> $LOC/$NAME/run.sh
echo "rembg i \$1 rembg_\$1" >> $LOC/$NAME/run.sh

read -p "Do you want to install to bin as $NAME (Y/n)? " userInput

if ! ([ "$userInput" == "n" ] || [ "$userInput" == "N" ]); then
    sudo cp $LOC/$NAME/run.sh /usr/bin/$NAME
    sudo chmod +rx /usr/bin/$NAME
    echo "$NAME installed to /usr/bin"
else
    echo "run.sh installed to $LOC/$NAME"
    echo "cd $LOC/$NAME"
fi