#!/bin/bash

FILE_NAME=$1

if [ "$FILE_NAME" == "" ]; then
    echo "Usage: ./clone_repos.sh <FILE_NAME>"
    exit 1
fi

if ! [ -f "$FILE_NAME" ]; then
    echo "File not found!"
    exit 1
fi

echo "" >> $FILE_NAME
while IFS= read -r line; do
    if ! [ -n "$line" ]; then
        continue
    fi

    repo_name=${line##*/}
    repo_name=${repo_name%%.*}

    PROJECT=$repo_name

    echo "Setting up project $PROJECT from ${line}"
    mkdir -p /srv/elixir-data/$PROJECT
    mkdir -p /srv/elixir-data/$PROJECT/data
    mkdir -p /srv/elixir-data/$PROJECT/repo

    git clone --recurse-submodules --remote-submodules "${line}" /srv/elixir-data/$PROJECT/repo
    git config --global --add safe.directory /srv/elixir-data/$PROJECT/repo

    export LXR_REPO_DIR="/srv/elixir-data/$PROJECT/repo"
    export LXR_DATA_DIR="/srv/elixir-data/$PROJECT/data"

    cd /usr/local/elixir/ && \
        ./script.sh list-tags && \
        python3 -u ./update.py && \
        chown -R www-data:www-data /srv/elixir-data/$PROJECT/repo

done < "$FILE_NAME"