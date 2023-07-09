@echo off
setlocal enabledelayedexpansion

set "packages=curl"
set "packages=%packages% wget"
set "packages=%packages% git"
set "packages=%packages% librewolf"
set "packages=%packages% spice-agent"
set "packages=%packages% qemu-guest-agent"
set "packages=%packages% virtio-drivers"

set "package_list="

for /f "delims=" %%p in ('echo %packages%') do (
    set "package_list=!package_list!%%p "
)

set "package_list=!package_list:~0,-1!"

echo Packages to be installed: !package_list!

choco install --ignore-checksums !package_list! -y