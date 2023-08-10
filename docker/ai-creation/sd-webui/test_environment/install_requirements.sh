#!/bin/bash

SCRIPT_RELATIVE_DIR=$(dirname "${BASH_SOURCE[0]}") 
cd $SCRIPT_RELATIVE_DIR 
ABSOLUTE_PATH=$(pwd)

LOC="$ABSOLUTE_PATH"
NAME="test"

mkdir -p $LOC/$NAME
cd $LOC/$NAME

python -m venv venv

source $LOC/$NAME/venv/bin/activate

$LOC/$NAME/venv/bin/pip install --upgrade pip wheel

mkdir $LOC/$NAME/build

git clone --recursive https://github.com/pytorch/pytorch.git $LOC/$NAME/build/pytorch

cd $LOC/$NAME/build/pytorch

$LOC/$NAME/venv/bin/pip install -r requirements.txt
$LOC/$NAME/venv/bin/pip install mkl mkl-include

$LOC/$NAME/venv/bin/python $LOC/$NAME/build/pytorch/tools/amd_build/build_amd.py

$LOC/$NAME/venv/bin/python setup.py develop

echo "All done"