#!/bin/bash

NAME="roop"
PYTHON_COMMAND="python"

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

git clone --depth 1 https://github.com/C0untFloyd/roop-unleashed.git $LOC/$NAME

if [ -e "cuda_test.py" ]; then
    cp cuda_test.py $LOC/$NAME/test_cuda.py
fi

cd $LOC/$NAME

$PYTHON_COMMAND -m venv .venv

source $LOC/$NAME/.venv/bin/activate

$LOC/$NAME/.venv/bin/pip install -r requirements.txt

args_roop="--keep-frames --keep-fps --many-faces"
args_quality="--video-encoder libx264 --video-quality 40 --execution-threads 16 --execution-provider cuda"

echo "#!/bin/bash" > $LOC/$NAME/run.sh
echo "source $LOC/$NAME/.venv/bin/activate" >> $LOC/$NAME/run.sh
echo "$LOC/$NAME/.venv/bin/python $LOC/$NAME/run.py $args_roop $args_quality" >> $LOC/$NAME/run.sh

# echo "#!/bin/bash" > $LOC/$NAME/$NAME.sh
# echo "source $LOC/$NAME/.venv/bin/activate" >> $LOC/$NAME/$NAME.sh
# echo "$LOC/$NAME/.venv/bin/python $LOC/$NAME/run.py -s \$1 -t \$2 -o output/\$3.mp4 $args_roop $args_quality" >> $LOC/$NAME/$NAME.sh
# echo 'IFS='.' read -ra parts <<< "$2"' >> $LOC/$NAME/$NAME.sh
# echo 'file_name=$(basename "${parts[0]}")' >> $LOC/$NAME/$NAME.sh
# echo 'file_dir=$(dirname "${parts[0]}")' >> $LOC/$NAME/$NAME.sh
# echo 'mv $file_dir/temp/$file_name frames/$3' >> $LOC/$NAME/$NAME.sh
# echo 'rm frames/$3/*.mp4' >> $LOC/$NAME/$NAME.sh


chmod +rx $LOC/$NAME/run.sh
# chmod +rx $LOC/$NAME/$NAME.sh

# sudo cp $LOC/$NAME/$NAME.sh /usr/bin/$NAME
# sudo chmod +rx /usr/bin/$NAME

echo "Installed $NAME in $LOC"
echo "Run ./run.sh to start it"
echo "cd $LOC/$NAME"