#!/bin/bash

directory="/opt/repos"

for file in "$directory"/*.zip; do
    ZIP_PATH=$(realpath "$file")
    if ! [ -f "$ZIP_PATH" ]; then
        continue
    fi

    repo_name=$(basename $ZIP_PATH .zip)
    PROJECT=$repo_name
    project_dir="/srv/elixir-data/$PROJECT"

    echo "Setting up project $PROJECT from ${ZIP_PATH}"
    mkdir -p $project_dir

    unzip -q "$ZIP_PATH" -d "$project_dir"
    rm "$ZIP_PATH"
    folder_name=$(ls -1d $project_dir/* | head -1)
    mv $folder_name $project_dir/repo

    git config --global --add safe.directory $project_dir/repo

    export LXR_REPO_DIR="$project_dir/repo"

    mkdir -p $project_dir/data
    export LXR_DATA_DIR="$project_dir/data"

    cd /usr/local/elixir/ && \
        ./script.sh list-tags && \
        python3 -u ./update.py && \
        chown -R www-data:www-data /srv/elixir-data/$PROJECT/repo

done