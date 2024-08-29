#!/bin/bash

# Install necessary packages
pacman -S vim fzf

# Font, Time
setfont ter-122b
timedatectl
echo "Verify that the timedatectl output above is correct"
echo "If so, run ./02-disk-partition.sh"
