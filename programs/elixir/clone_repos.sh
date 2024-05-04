#!/bin/bash

# PROJECT=$1
FILE_NAME=$1

# if [ "$PROJECT" == "" ]; then
#     echo "Usage: ./clone_repos.sh <PROJECT_NAME> <FILE_NAME>"
#     exit 1
# fi

if [ "$FILE_NAME" == "" ]; then
    echo "Usage: ./clone_repos.sh <FILE_NAME>"
    exit 1
fi

if ! [ -f "$FILE_NAME" ]; then
    echo "File not found!"
    exit 1
fi

# mkdir -p /srv/elixir-data/$PROJECT/repo/
cd /srv/elixir-data/projects

# echo "RUNNING SCRIPT"

echo "" >> $FILE_NAME
while IFS= read -r line; do
    if ! [ -n "$line" ]; then
        continue
    fi

    repo_name=${line##*/}
    repo_name=${repo_name%%.*}

    echo "Cloning project $repo_name from ${line}"
    mkdir -p /srv/elixir-data/projects/$repo_name
    mkdir -p /srv/elixir-data/projects/$repo_name/data
    mkdir -p /srv/elixir-data/projects/$repo_name/repo

    git clone --bare "${line}" /srv/elixir-data/projects/$repo_name/repo

done < "$FILE_NAME"


# git config --global --add safe.directory /srv/elixir-data/$PROJECT/repo