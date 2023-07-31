#!/bin/bash

NAME="InvokeAI"

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

mkdir -p $LOC/$NAME
cd $LOC/$NAME

python -m venv .venv --prompt InvokeAI

source $LOC/$NAME/.venv/bin/activate

$LOC/$NAME/.venv/bin/pip install InvokeAI --use-pep517 --extra-index-url https://download.pytorch.org/whl/rocm5.4.2

echo "#!/bin/bash" > $LOC/$NAME/configure.sh
echo "source $LOC/$NAME/.venv/bin/activate" >> $LOC/$NAME/configure.sh
echo "invokeai-configure" >> $LOC/$NAME/configure.sh
chmod +rx $LOC/$NAME/configure.sh

echo "#!/bin/bash" > $LOC/$NAME/run.sh
echo "source $LOC/$NAME/.venv/bin/activate" >> $LOC/$NAME/run.sh
echo "invokeai-web" >> $LOC/$NAME/run.sh
chmod +rx $LOC/$NAME/run.sh

echo "cd $LOC/$NAME"
echo "./configure.sh"