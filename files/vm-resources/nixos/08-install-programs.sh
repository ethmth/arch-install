#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
        echo "This script should not be run with root/sudo privileges."
        exit 1
fi

CUR_USER=$(whoami)

FOLDER_NAME=$(ls /mnt/share | fzf --prompt="Select the folder")

SOURCE="/mnt/share/$FOLDER_NAME/downloaders/mine"

if ! [ -e "$SOURCE" ]; then
    echo "No action yet configured for $FOLDER_NAME."
    exit 1
fi

destination="/home/$CUR_USER/bin"

search_files() {
  local dir="$1"

  for file in "$dir"/*; do
    if [ -d "$file" ]; then
      search_files "$file"
    elif [ -f "$file" ] && [[ "$file" == *.sh || "$file" == *.py ]]; then
      file_without_extension="${file%.*}"
      file_without_extension=$(basename "$file_without_extension")
      cp "$file" "$destination/$file_without_extension"
      chmod +x "$destination/$file_without_extension"

      echo "Copied and made executable: $file_without_extension"
    fi
  done
}

if [ ! -d "$destination" ]; then
  mkdir -p "$destination"
fi

search_files "$SOURCE"

echo "Programs installed to bin"