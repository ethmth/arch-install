#!/bin/bash


# Edit config.plist first
# Guide for generating values: https://dortania.github.io/OpenCore-Post-Install/universal/iservices.html#using-gensmbios

exit

# To generate new OpenCore image
./opencore-image-ng.sh --cfg config.plist --img OpenCore.qcow2

# To edit config.plist inside OpenCore Image
EDITOR=vim virt-edit -m /dev/sda1 OpenCore.qcow2 /EFI/OC/config.plist