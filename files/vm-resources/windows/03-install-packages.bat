@echo off
setlocal enabledelayedexpansion

set "packages=curl"
set "packages=%packages% wget"
set "packages=%packages% git"
set "packages=%packages% ddu"
set "packages=%packages% firefox"
set "packages=%packages% vlc"
set "packages=%packages% notepadplusplus"
set "packages=%packages% librewolf"
set "packages=%packages% steam"
set "packages=%packages% ea-app"
set "packages=%packages% python"
set "packages=%packages% 7zip"
set "packages=%packages% epicgameslauncher"
set "packages=%packages% chromium"
set "packages=%packages% tor-browser"
set "packages=%packages% prismlauncher"
set "packages=%packages% qbittorrent"
set "packages=%packages% discord"
set "packages=%packages% audacity"
set "packages=%packages% obs-studio"
set "packages=%packages% vscode"
set "packages=%packages% virtio-drivers"

:: set "packages=%packages% spice-agent"
:: set "packages=%packages% qemu-guest-agent"

set "package_list="

for /f "delims=" %%p in ('echo %packages%') do (
    set "package_list=!package_list!%%p "
)

set "package_list=!package_list:~0,-1!"

echo Packages to be installed: !package_list!

choco install !package_list! -y