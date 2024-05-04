#!/bin/bash

directory="/opt/repos"
# unzip_directory="/srv/elixir-data/$PROJECT/repo"

# find "$repository_directory" -type f -name "*.zip" -print0 |
# while IFS= read -r -d '' zipfile; do
#     echo "Processing zip file: $zipfile"
#     1
#     # Do something with each zip file, for example:
#     # You can unzip the file, process its contents, etc.
# done

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
    # mkdir -p /srv/elixir-data/$PROJECT/repo

    unzip -q "$ZIP_PATH" -d "$project_dir"
    folder_name=$(ls -1d $project_dir/* | head -1)
    mv $folder_name $project_dir/repo

    # git clone --recurse-submodules --remote-submodules "${line}" /srv/elixir-data/$PROJECT/repo
    git config --global --add safe.directory $project_dir/repo

    export LXR_REPO_DIR="$project_dir/repo"

    mkdir -p $project_dir/data
    export LXR_DATA_DIR="$project_dir/data"

    cd /usr/local/elixir/ && \
        ./script.sh list-tags && \
        python3 -u ./update.py && \
        chown -R www-data:www-data /srv/elixir-data/$PROJECT/repo

done