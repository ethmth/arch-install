#!/bin/bash

PROJECT=$1
FILE_NAME=$2

if [ "$PROJECT" == "" ]; then
    echo "Usage: ./clone_repos.sh <PROJECT_NAME> <FILE_NAME>"
    exit 1
fi

if [ "$FILE_NAME" == "" ]; then
    echo "Usage: ./clone_repos.sh <PROJECT_NAME> <FILE_NAME>"
    exit 1
fi

mkdir -p /srv/elixir-data/$PROJECT/repo/
cd /srv/elixir-data/$PROJECT/repo/

if [ -f "$FILE_NAME" ]; then
    while IFS= read -r line; do
        if [ -n "$line" ]; then
            git clone --bare "${line}"
        fi
    done < "$FILE_NAME"
else
    echo "File not found!"
    exit 1
fi

# git config --global --add safe.directory /srv/elixir-data/$PROJECT/repo