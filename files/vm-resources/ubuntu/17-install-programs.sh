#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
        echo "This script should not be run with root/sudo privileges."
        exit 1
fi

SCRIPT_PATH=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT_PATH")

CUR_USER=$(whoami)

FOLDER_NAME=$(ls /home/$CUR_USER/share | fzf --prompt="Select the folder")

if [ "$FOLDER_NAME" == "SecurePrograms" ]; then
  SOURCE="/home/$CUR_USER/share/$FOLDER_NAME/downloaders/mine"
elif [ "$FOLDER_NAME" == "SecureSoftware" ]; then
  SOURCE="/home/$CUR_USER/share/$FOLDER_NAME/APK/installer"
fi

if ! [ -e "$SOURCE" ]; then
    echo "No action yet configured for $FOLDER_NAME."
    exit 1
fi

if [ "$FOLDER_NAME" == "SecurePrograms" ]; then
  destination="/usr/local/bin"
elif [ "$FOLDER_NAME" == "SecureSoftware" ]; then
  destination="/home/$CUR_USER/android"
  mkdir -p $destination
fi

search_files() {
  local dir="$1"

  for file in "$dir"/*; do
    if [ -d "$file" ]; then
      search_files "$file"
    elif [ -f "$file" ] && [[ "$file" == *.sh || "$file" == *.py ]]; then
      file_without_extension="${file%.*}"
      file_without_extension=$(basename "$file_without_extension")
      sudo cp "$file" "$destination/$file_without_extension"

      sudo chmod +rx "$destination/$file_without_extension"

      echo "Copied and made executable: $file_without_extension"
    fi
  done
}

if [ "$FOLDER_NAME" == "SecurePrograms" ]; then
  search_files "$SOURCE"
  echo "Programs installed to /usr/local/bin"
elif [ "$FOLDER_NAME" == "SecureSoftware" ]; then
  if [ -f "$SCRIPT_DIR/apk-install" ]; then
    cp "$SCRIPT_DIR/apk-install" $destination/apk-install
    chmod +x $destination/apk-install
  fi
  if [ -f "$SCRIPT_DIR/phone" ]; then
    sudo cp "$SCRIPT_DIR/phone" /usr/local/bin/phone
    sudo chmod +rx /usr/local/bin/phone
  fi
  cp -r $SOURCE $destination
  echo "Android installer installed to ~/android/installer"
fi