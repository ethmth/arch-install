#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi

CUR_USER=$(whoami)
source /home/$CUR_USER/arch-install/config/system.conf
source /home/$CUR_USER/arch-install/config/network-interface.conf

# Install Magic Status Executables
if (( PLASMA )); then
	echo "Installing Plasma Widget - Magic Status Executables..."
    sudo -k git clone https://github.com/ethmth/magic-status-executables.git /usr/share/plasma/plasmoids/com.github.ethmth.magic-status-executables
fi

# Install spacemacs
echo "Installing spacemacs..."
git clone https://github.com/syl20bnr/spacemacs /home/$CUR_USER/.emacs.d

# Github Login
echo "Login to Github..."
git config --global credential.helper store
read -p "What is your Github username?: " git_user
read -p "What is your Github email?: " git_email
git config --global user.name "$git_user"
git config --global user.email "$git_email"

# Set Default Java Version for Arch Linux
sudo -k archlinux-java set java-17-openjdk

# SSH-keygen
sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | ssh-keygen
    # default dir 
    # no password
    # no password confirm
EOF

mkdir -p /home/$CUR_USER/Documents/Programs
mkdir -p /home/$CUR_USER/Pictures/Wallpapers
mkdir -p /home/$CUR_USER/Downloads

wget -O /home/$CUR_USER/Pictures/Wallpapers/wallpaper.png https://4kwallpapers.com/images/wallpapers/windows-11-purple-abstract-dark-background-dark-purple-dark-3840x2400-8995.png

# source pyenv
echo 'eval "$(pyenv init -)"' >> /home/$CUR_USER/.bashrc

# default apps
mkdir -p /home/$CUR_USER/.config/xfce4
cp /etc/xdg/xfce4/helpers.rc /home/$CUR_USER/.config/xfce4/helpers.rc
xdg-mime default thunar.desktop inode/directory
if (( HYPRLAND )); then
    xdg-mime default Alacritty.desktop application/x-shellscript
    xdg-mime default Alacritty.desktop application/x-terminal-emulator
    bash /home/$CUR_USER/arch-install/util/kernel/config-update.sh /home/$CUR_USER/.config/xfce4/helpers.rc "TerminalEmulator=alacritty"
else
    xdg-mime default qterminal.desktop application/x-shellscript
    xdg-mime default qterminal.desktop application/x-terminal-emulator
    bash /home/$CUR_USER/arch-install/util/kernel/config-update.sh /home/$CUR_USER/.config/xfce4/helpers.rc "TerminalEmulator=qterminal"
fi
sudo update-mime-database /usr/share/mime

# npm user setup
echo "export npm_config_prefix=\"\$HOME/.local\"" >> /home/$CUR_USER/.bashrc

# Docker container runtime setup
string_to_echo=$(echo '{
  "runtimes": {
    "nvidia": {
      "path": "/usr/bin/nvidia-container-runtime",
      "runtimeArgs": []
    }
  }
}')

sudo mkdir -p /etc/docker
sudo sh -c "echo '$string_to_echo' > /etc/docker/daemon.json"


echo "Verify that installation of various misc software was successful"
echo "If so, run ./08-scripts.sh"
