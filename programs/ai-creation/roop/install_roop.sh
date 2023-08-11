#!/bin/bash

NAME="roop"
PYTHON_COMMAND="python3.10"
# ONNXRUNTIME_VERSION="1.14.1"

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
fi

if (( AMD_GPU )); then
    NAME="$NAME-amd"
fi

git clone --depth 1 https://github.com/s0md3v/roop.git $LOC/$NAME

if [ -e "requirements.pip" ]; then
    cp requirements.pip $LOC/$NAME/requirements.pip
fi

cd $LOC/$NAME

$PYTHON_COMMAND -m venv .venv

source $LOC/$NAME/.venv/bin/activate

$LOC/$NAME/.venv/bin/pip install -r requirements.txt

if (( AMD_GPU )); then
    $LOC/$NAME/.venv/bin/pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/rocm5.4.2
    $LOC/$NAME/.venv/bin/pip uninstall onnxruntime
    git clone https://github.com/microsoft/onnxruntime
    cd onnxruntime
    # $LOC/$NAME/.venv/bin/pip install ninja cmake
    # wget -O $LOC/$NAME/onnxruntime/build/Linux/Release/_deps/onnx-subbuild/onnx-populate-prefix/src/rel-1.14.1.zip https://github.com/onnx/onnx/archive/refs/heads/rel-1.14.1.zip
    ./build.sh --config Release --build_wheel --update --build --parallel --cmake_extra_defines CMAKE_PREFIX_PATH=/opt/rocm/lib/cmake ONNXRUNTIME_VERSION=$ONNXRUNTIME_VERSION onnxruntime_BUILD_UNIT_TESTS=off --use_rocm --rocm_home=/opt/rocm
    exit 1
    $LOC/$NAME/.venv/bin/pip install build/Linux/Release/dist/*.whl
els
    $LOC/$NAME/.venv/bin/pip uninstall onnxruntime onnxruntime-gpu
    $LOC/$NAME/.venv/bin/pip install torch torchvision torchaudio --force-reinstall --index-url https://download.pytorch.org/whl/cu118
    $LOC/$NAME/.venv/bin/pip install onnxruntime-gpu
fi

echo "#!/bin/bash" > $LOC/$NAME/run.sh
echo "source $LOC/$NAME/.venv/bin/activate" >> $LOC/$NAME/run.sh
echo "$LOC/$NAME/.venv/bin/python $LOC/$NAME/run.py" >> $LOC/$NAME/run.sh

echo "#!/bin/bash" > $LOC/$NAME/cuda-run.sh
echo "source $LOC/$NAME/.venv/bin/activate" >> $LOC/$NAME/cuda-run.sh
echo "$LOC/$NAME/.venv/bin/python $LOC/$NAME/run.py --execution-provider cuda" >> $LOC/$NAME/cuda-run.sh

echo "#!/bin/bash" > $LOC/$NAME/$NAME.sh
echo "source $LOC/$NAME/.venv/bin/activate" >> $LOC/$NAME/$NAME.sh
if (( AMD_GPU )); then
echo "$LOC/$NAME/.venv/bin/python $LOC/$NAME/run.py -s \$1 -t \$2 -o output/\$3.mp4 --keep-frames --keep-fps --many-faces" >> $LOC/$NAME/$NAME.sh
else
echo "$LOC/$NAME/.venv/bin/python $LOC/$NAME/run.py -s \$1 -t \$2 -o output/\$3.mp4 --keep-frames --keep-fps --many-faces --execution-provider cuda" >> $LOC/$NAME/$NAME.sh
fi
echo 'IFS='.' read -ra parts <<< "$2"' >> $LOC/$NAME/$NAME.sh
echo 'file_name=$(basename "${parts[0]}")' >> $LOC/$NAME/$NAME.sh
echo 'file_dir=$(dirname "${parts[0]}")' >> $LOC/$NAME/$NAME.sh
echo 'mv $file_dir/temp/$file_name frames/$3' >> $LOC/$NAME/$NAME.sh
echo 'rm frames/$3/*.mp4' >> $LOC/$NAME/$NAME.sh

if grep -q "^MAX_PROBABILITY =" $LOC/$NAME/roop/predictor.py; then
    sed -i "s|^MAX_PROBABILITY =.*|MAX_PROBABILITY = 9999|" $LOC/$NAME/roop/predictor.py
fi

chmod +rx $LOC/$NAME/run.sh
chmod +rx $LOC/$NAME/cuda-run.sh
chmod +rx $LOC/$NAME/$NAME.sh

sudo cp $LOC/$NAME/$NAME.sh /usr/bin/$NAME
sudo chmod +rx /usr/bin/$NAME

echo "Installed $NAME in $LOC"
echo "Run ./run.sh to start it"
echo "cd $LOC/$NAME"