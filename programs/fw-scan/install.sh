#!/bin/bash

PYTHON_VERSION="3.11"

NAME="fw-scan"

FILES="
fw-scan.py
requirements.pip
"

if ! [[ $EUID -ne 0 ]]; then
    echo "This script should not be run with root/sudo privileges."
    exit 1
fi

LOC=$(lsblk --noheadings -o MOUNTPOINTS | grep -v '^$' | grep -v "/boot" | fzf --prompt="Select your desired $NAME installation location")

if ([ "$LOC" == "" ] || [ "$LOC" == "Cancel" ]); then
    echo "Nothing was selected. Run this script again with target drive mounted."
    exit 1
fi

if [ "$LOC" == "/" ]; then
    LOC="$HOME"
fi

if ! [ -d "$LOC" ]; then
    echo "Your location is not available. Is the disk mounted? Do you have access?"
	exit 1
fi

LOC="$LOC/programs"
mkdir -p $LOC/$NAME


for file in $FILES; do
    if [ -d "$file" ]; then
        cp -r $file $LOC/$NAME/
    elif [ -f "$file" ]; then
        cp $file $LOC/$NAME/$file
    fi
done

cd $LOC/$NAME

pyenv install $PYTHON_VERSION
export PYENV_VERSION=$PYTHON_VERSION

# pyenv exec python -m venv .venv
# source $LOC/$NAME/.venv/bin/activate

# pyenv exec $LOC/$NAME/.venv/bin/pip install -r requirements.pip
pyenv exec pip install -r requirements.pip

echo "#!/bin/bash
export PYENV_VERSION=$PYTHON_VERSION
#source $LOC/$NAME/.venv/bin/activate
#pyenv exec $LOC/$NAME/.venv/bin/python $LOC/$NAME/fw-scan.py \"\$@\"
pyenv exec python $LOC/$NAME/fw-scan.py
" >> $LOC/$NAME/run.sh
chmod +rx $LOC/$NAME/run.sh

sudo cp $LOC/$NAME/run.sh /usr/local/bin/fw-scan
sudo chmod +rx /usr/local/bin/fw-scan