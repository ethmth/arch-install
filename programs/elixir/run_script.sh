#!/bin/bash

directory="/srv/elixir-data/projects"

find "$directory" -maxdepth 1 -type d -print0 |
while IFS= read -r -d '' dir; do
    REPO_DIR="$dir/repo"
    DATA_DIR="$dir/data"

    LXR_REPO_DIR=$REPO_DIR ./script.sh list-tags
    # Do something with each directory, for example:
    # You can access "$dir" inside this loop for further operations
done
