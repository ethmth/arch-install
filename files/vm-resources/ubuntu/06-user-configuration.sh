#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script must not be run with root/sudo privileges."
	exit 1
fi
CUR_USER=$(whoami)

SCRIPT_PATH=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT_PATH")

gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'
gsettings set org.gnome.desktop.session idle-delay 0

echo "Set gsettings"

if ! [ -f "$SCRIPT_DIR/pingphone.desktop" ]; then
    echo "$SCRIPT_DIR/pingphone.desktop not found"
    exit 0
fi


mkdir -p /home/$CUR_USER/.config/autostart

cp "$SCRIPT_DIR/pingphone.desktop" /home/$CUR_USER/.config/autostart/pingphone.desktop


mkdir -p /home/$CUR_USER/.config/xfce4
cp /etc/xdg/xfce4/helpers.rc /home/$CUR_USER/.config/xfce4/helpers.rc
xdg-mime default thunar.desktop inode/directory
sed -i "s|^TerminalEmulator=.*|TerminalEmulator=gnome-terminal|" /home/$CUR_USER/.config/xfce4/helpers.rc
sudo update-mime-database /usr/share/mime

mkdir -p /home/$CUR_USER/.ssh

echo "Host phone
    Hostname 10.152.153.15
    User u0_a154
    Port 8022" > /home/$CUR_USER/.ssh/config


echo "export SSHPASS=\"password\"" >> /home/$CUR_USER/.bashrc

git config --global alias.pr '!f() { git fetch -fu ${2:-origin} refs/pull/$1/head:pr/$1 && git checkout pr/$1; }; f'
git config --global http.version HTTP/1.1
git config --global core.compression 0
git config --global http.postBuffer 524288000

if ! [ -f "$SCRIPT_DIR/get-cookies" ]; then
    echo "$SCRIPT_DIR/get-cookies not found"
    exit 0
fi

sudo cp $SCRIPT_DIR/get-cookies /usr/bin/get-cookies
sudo chmod +rx /usr/bin/get-cookies