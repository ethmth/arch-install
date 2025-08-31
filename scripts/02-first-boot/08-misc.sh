#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi

CUR_USER=$(whoami)
source /home/$CUR_USER/arch-install/config/system.conf
source /home/$CUR_USER/arch-install/config/network-interface.conf

# alias my-git
if ! ( cat "/home/$CUR_USER/.bashrc" | grep -q 'alias git="my-git"' ); then
    echo 'alias git="my-git"' >> /home/$CUR_USER/.bashrc
    source /home/$CUR_USER/.bashrc
fi

# add google cloud to bin
if ! ( cat "/home/$CUR_USER/.bashrc" | grep -q 'source /etc/profile.d/google-cloud-cli.sh' ); then
    echo 'source /etc/profile.d/google-cloud-cli.sh' >> /home/$CUR_USER/.bashrc
    source /home/$CUR_USER/.bashrc
fi

# Install Magic Status Executables
if (( PLASMA )); then
	echo "Installing Plasma Widget - Magic Status Executables..."
    if ! [ -d "/usr/share/plasma/plasmoids/com.github.ethmth.magic-status-executables" ]; then
        sudo -k git clone https://github.com/ethmth/magic-status-executables.git /usr/share/plasma/plasmoids/com.github.ethmth.magic-status-executables
    fi
fi

# Install spacemacs
if ! [ -d "/home/$CUR_USER/.emacs.d" ]; then
echo "Installing spacemacs..."
git clone https://github.com/syl20bnr/spacemacs /home/$CUR_USER/.emacs.d
fi

# Github Login
# echo "Login to Github..."
if ! (git config --global credential.helper); then
git config --global credential.helper store
git config --global credential.useHttpPath true
fi
if ! (git config --global user.name); then
read -p "What is your Github username?: " git_user
git config --global user.name "$git_user"
fi
if ! (git config --global user.email); then
read -p "What is your Github email?: " git_email
git config --global user.email "$git_email"
fi

# Set Default Java Version for Arch Linux
sudo -k archlinux-java set java-17-openjdk

# SSH-keygen
if ! ([ -f "/home/$CUR_USER/.ssh/id_rsa" ] || [ -f "/home/$CUR_USER/.ssh/id_ed25519" ]); then
sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | ssh-keygen
    # default dir 
    # no password
    # no password confirm
EOF
fi

mkdir -p /home/$CUR_USER/Documents/Programs
mkdir -p /home/$CUR_USER/Pictures/Wallpapers
mkdir -p /home/$CUR_USER/Downloads

if ! [ -f "/home/$CUR_USER/Pictures/Wallpapers/wallpaper.png" ]; then
wget -O /home/$CUR_USER/Pictures/Wallpapers/wallpaper.png https://4kwallpapers.com/images/wallpapers/windows-11-purple-abstract-dark-background-dark-purple-dark-3840x2400-8995.png
fi

if ! [ -f "/home/$CUR_USER/Pictures/Wallpapers/wallpaper2.jpg" ]; then
wget -O /home/$CUR_USER/Pictures/Wallpapers/wallpaper2.jpg https://512pixels.net/downloads/macos-wallpapers-6k/12-Dark.jpg
fi

# source pyenv
if ! ( cat "/home/$CUR_USER/.bashrc" | grep -q 'eval "$(pyenv init -)"' ); then
echo 'eval "$(pyenv init -)"' >> /home/$CUR_USER/.bashrc
fi
#if ! ( cat "/home/$CUR_USER/.bashrc" | grep -q 'eval $(opam env)' ); then
#echo 'eval $(opam env)' >> /home/$CUR_USER/.bashrc
#fi

# default apps
mkdir -p /home/$CUR_USER/.config/xfce4
cp /etc/xdg/xfce4/helpers.rc /home/$CUR_USER/.config/xfce4/helpers.rc
xdg-mime default thunar.desktop inode/directory
if (( HYPRLAND )); then
    xdg-mime default org.codeberg.dnkl.foot.desktop application/x-shellscript
    xdg-mime default org.codeberg.dnkl.foot.desktop application/x-terminal-emulator
    bash /home/$CUR_USER/arch-install/util/kernel/config-update.sh /home/$CUR_USER/.config/xfce4/helpers.rc "TerminalEmulator=foot"
else
    xdg-mime default qterminal.desktop application/x-shellscript
    xdg-mime default qterminal.desktop application/x-terminal-emulator
    bash /home/$CUR_USER/arch-install/util/kernel/config-update.sh /home/$CUR_USER/.config/xfce4/helpers.rc "TerminalEmulator=qterminal"
fi
sudo update-mime-database /usr/share/mime


# clear thunar recently used
echo "<?xml version="1.0" encoding="UTF-8"?>
<xbel version="1.0"
      xmlns:bookmark="http://www.freedesktop.org/standards/desktop-bookmarks"
      xmlns:mime="http://www.freedesktop.org/standards/shared-mime-info"
></xbel>" > /home/$CUR_USER/.local/share/recently-used.xbel
sudo chattr +i /home/$CUR_USER/.local/share/recently-used.xbel

# android home
# NOW I've put ANDROID_HOME in hyprland.conf, so this is no longer needed
#if ! ( cat "/home/$CUR_USER/.bashrc" | grep -q "export ANDROID_HOME=\"/home/$CUR_USER/Android/Sdk\"" ); then
#echo "export ANDROID_HOME=\"/home/$CUR_USER/Android/Sdk\"" >> /home/$CUR_USER/.bashrc
#fi

# npm user setup
if ! ( cat "/home/$CUR_USER/.bashrc" | grep -q "export npm_config_prefix=\"\$HOME/.local\"" ); then
echo "export npm_config_prefix=\"\$HOME/.local\"" >> /home/$CUR_USER/.bashrc
fi

if ! ( cat "/home/$CUR_USER/.bashrc" | grep -q "osc7_cwd()" ); then
echo "osc7_cwd() {
    local strlen=\${#PWD}
    local encoded=\"\"
    local pos c o
    for (( pos=0; pos<strlen; pos++ )); do
        c=\${PWD:\$pos:1}
        case \"\$c\" in
            [-/:_.!\'\(\)~[:alnum:]] ) o=\"\${c}\" ;;
            * ) printf -v o '%%%02X' \"'\${c}\" ;;
        esac
        encoded+=\"\${o}\"
    done
    printf '\e]7;file://%s%s\e\\\' \"\${HOSTNAME}\" \"\${encoded}\"
}
PROMPT_COMMAND=\${PROMPT_COMMAND:+\$PROMPT_COMMAND; }osc7_cwd" >> /home/$CUR_USER/.bashrc
fi

if ! ( cat "/home/$CUR_USER/.bashrc" | grep -q "PATH=\$PATH:/home/$CUR_USER/.local/bin" ); then
echo "PATH=\$PATH:/home/$CUR_USER/.local/bin" >> /home/$CUR_USER/.bashrc
fi

if ! ( cat "/home/$CUR_USER/.bashrc" | grep -q "PATH=\$PATH:/home/$CUR_USER/.dotnet/tools" ); then
echo "PATH=\$PATH:/home/$CUR_USER/.dotnet/tools" >> /home/$CUR_USER/.bashrc
fi

# Set bash history to delete
#if ! ( cat "/home/$CUR_USER/.bashrc" | grep -q "cat /dev/null > ~/.bash_history && history -c" ); then
#echo "cat /dev/null > ~/.bash_history && history -c" >> /home/$CUR_USER/.bashrc
#fi

#if ! ([ -f "/home/$CUR_USER/.bash_logout" ] && ( cat "/home/$CUR_USER/.bash_logout" | grep -q "cat /dev/null > ~/.bash_history && history -c" )); then
#echo "cat /dev/null > ~/.bash_history && history -c" >> /home/$CUR_USER/.bash_logout
#fi

# if ! ( cat "/home/$CUR_USER/.bashrc" | grep -q "unset HISTFILE" ); then
# echo "unset HISTFILE" >> /home/$CUR_USER/.bashrc
# fi

if ! ( cat "/home/$CUR_USER/.bashrc" | grep -q "HISTFILE=/home/" ); then
echo "HISTFILE=/home/$CUR_USER/.history/.bash_history
PROMPT_COMMAND=\"\${PROMPT_COMMAND:+\$PROMPT_COMMAND; }history -a\"" >> /home/$CUR_USER/.bashrc
fi

# Docker container runtime setup
if (( NVIDIA )); then
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
fi

# Disable kdewallet
if (( PLASMA )); then
kwriteconfig5 --file kwalletrc --group 'Wallet' --key 'Enabled' 'false'
kwriteconfig5 --file kwalletrc --group 'Wallet' --key 'First Use' 'false'
fi

# Enable NTP
sudo timedatectl set-ntp true

# TODO: Implement these in RAM/also clipboard and bash history.
RAM_DIRS="
/home/$CUR_USER/.history
/home/$CUR_USER/.cache/thumbnails
/home/$CUR_USER/.cache/virt-manager
/home/$CUR_USER/.cache/mpv
/home/$CUR_USER/.cache/libvirt
/home/$CUR_USER/.cache/yt-dlp
/home/$CUR_USER/.cache/gallery-dl
/home/$CUR_USER/.cache/cliphist
"

OLD_IFS=$IFS

IFS=$'\n'

for dir in $RAM_DIRS; do
    if ! ( cat "/etc/fstab" | grep -q "$dir" ); then
        USER_ID=$(id -u $CUR_USER)
        GROUP_ID=$(id -g $CUR_USER)
        FSTAB_LINE="none $dir  tmpfs   rw,noexec,nosuid,size=3%,uid=$USER_ID,gid=$GROUP_ID,mode=0755,noatime   0   0"
        sudo sh -c "echo \"$FSTAB_LINE\" >> /etc/fstab"
    fi
done

IFS=$OLD_IFS

# Add delay to logins
if ! ( cat "/etc/pam.d/system-login" | grep -q "pam_faildelay.so delay=4000000" ); then
    LINE="auth optional pam_faildelay.so delay=4000000"
    sudo sh -c "echo \"$LINE\" >> /etc/pam.d/system-login"
fi

# tmux config
if ! ( [ -f "/home/$CUR_USER/.tmux.conf" ] && ( cat "/home/$CUR_USER/.tmux.conf" | grep -q 'set -g mouse on' ) ); then
    echo 'set -g mouse on' >> /home/$CUR_USER/.tmux.conf
fi

# Add this to /etc/NetworkManager/conf.d/rc-manager.conf.
sudo sh -c "echo '[main]
rc-manager=resolvconf' > /etc/NetworkManager/conf.d/rc-manager.conf"

echo "Verify that installation of various misc software was successful"
echo "If so, run ./09-split-workspaces.sh"
