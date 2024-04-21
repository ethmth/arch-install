#!/bin/bash

GODOT_VERSION="4.2.2"
NAME="godot$GODOT_VERSION"

if ! [[ $EUID -ne 0 ]]; then
    echo "This script should not be run with root/sudo privileges."
    exit 1
fi

if ! [ -f "godot.desktop" ]; then
    echo "Make sure you're in the correct directory with godot.desktop"
    exit 1
fi
DESKTOP_FILE="$(pwd)/godot.desktop"

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

LOC="$LOC/programs/$NAME"
mkdir -p $LOC

cd $LOC
wget https://github.com/godotengine/godot/releases/download/$GODOT_VERSION-stable/Godot_v$GODOT_VERSION-stable_linux.x86_64.zip
unzip Godot_v$GODOT_VERSION-stable_linux.x86_64.zip

echo "#!/bin/bash" > run.sh
echo "$LOC/Godot_v$GODOT_VERSION-stable_linux.x86_64 --single-window" >> run.sh
chmod +rx run.sh

cp $DESKTOP_FILE $NAME.desktop
sed -i "s/GODOT_VERSION/$GODOT_VERSION/g" $NAME.desktop

sudo cp run.sh /usr/bin/$NAME
sudo chmod +rx /usr/bin/$NAME
sudo cp $NAME.desktop /usr/share/applications/$NAME.desktop
sudo chmod 644 /usr/share/applications/$NAME.desktop

echo "Installed $NAME in $LOC"
echo "Run $NAME to start it"