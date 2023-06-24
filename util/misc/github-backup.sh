#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
        echo "This script should not be run with root/sudo privileges."
        exit 1
fi

CUR_USER=$(whoami)

current_directory=$(pwd)
last_three_directories=$(basename "$(dirname "$(dirname "$current_directory")")")/$(basename "$(dirname "$current_directory")")/$(basename "$current_directory")

if ! [ "$last_three_directories" == "arch-install/util/misc" ]; then
    echo "Please run this script in arch-install/util/misc"
    exit 1
fi

if [ $# -ne 1 ]; then
  echo "Usage: $0 <github_username>"
  exit 1
fi

github_username=$1

mkdir -p workdir/repos
cd workdir/repos

echo "Cloning repositories for $github_username..."
repos_url="https://api.github.com/users/$github_username/repos?per_page=100"
repos=$(curl -s "$repos_url" | grep -o 'git://[^"]*')

for repo in $repos; do
    repo=${repo/git:\/\//https:\/\/}
    echo "Repo: $repo"
    git clone "$repo"
done

echo "Cloning completed."

echo "Creating zip files for cloned repositories..."

cd ..
mkdir -p "${github_username}_$(date +'%Y%m%d')"
cd repos

for repo_dir in ./*; do
    echo "$repo_dir"
    if [ -d "$repo_dir" ]; then
        repo_name=$(basename "$repo_dir")
        zip_file="../${github_username}_$(date +'%Y%m%d')/${repo_name}_$(date +'%Y%m%d').zip"

        echo "zip -qr \"$zip_file\" \"$repo_dir\""
        zip -qr "$zip_file" "$repo_dir"
        echo "Created $zip_file"
    fi
done

echo "Zip file creation completed."