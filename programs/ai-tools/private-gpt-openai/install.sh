#!/bin/bash

NAME="private-gpt-openai"

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

git clone https://github.com/zylon-ai/private-gpt $LOC/$NAME
cd $LOC/$NAME

pyenv install 3.11
pyenv local 3.11

pip install poetry

poetry install --extras "ui llms-openai embeddings-openai vector-stores-qdrant"

read -p "What is your OpenAI API Key? (https://platform.openai.com/api-keys) " api_key

if [ "$api_key" == "" ]; then
    echo "No key provided"
    exit 1
fi

echo "#!/bin/bash
cd $LOC/$NAME
PGPT_PROFILES=openai OPENAI_API_KEY=$api_key make run
" > $LOC/$NAME/run.sh

chmod +rx $LOC/$NAME/run.sh

echo "$NAME installed to $LOC/$NAME"
echo "Run ./run.sh to start"