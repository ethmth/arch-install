#!/bin/bash

NAME="ill-cover-you"
PYTHON_COMMAND="python"

if ! [[ $EUID -ne 0 ]]; then
        echo "This script should not be run with root/sudo privileges."
        exit 1
fi

CUR_USER=$(whoami)

LOC="/home/$CUR_USER/programs"
mkdir -p $LOC

git clone https://github.com/ethmth/ill-cover-you.git $LOC/$NAME

cp $LOC/$NAME/config.env.example $LOC/$NAME/config.env

cd $LOC/$NAME

$PYTHON_COMMAND -m venv .venv

source $LOC/$NAME/.venv/bin/activate

$LOC/$NAME/.venv/bin/pip install -r requirements.txt

echo "#!/bin/bash" > $LOC/$NAME/run.sh
echo "source $LOC/$NAME/.venv/bin/activate" >> $LOC/$NAME/run.sh
echo "$LOC/$NAME/.venv/bin/python $LOC/$NAME/gui.py" >> $LOC/$NAME/run.sh

chmod +rx $LOC/$NAME/run.sh

sudo cp $LOC/$NAME/run.sh /usr/bin/$NAME
sudo chmod +rx /usr/bin/$NAME

echo "Installed $NAME in $LOC"
echo "Edit the environment file to begin using it:"
echo "vim $LOC/$NAME/config.env"

vim $LOC/$NAME/config.env

echo "Copy your resume to $LOC/$NAME/resume.pdf"
echo "Run '$NAME' to start it"

echo "Find your access token by visiting https://chat.openai.com/api/auth/session"