#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should NOT be run with root/sudo privileges."
	exit 1
fi

# add 'max-jobs = auto' to /etc/nix/nix.conf

# add 'experimental-features = nix-command flakes' to /etc/nix/nix.conf

nix-channel --add https://channels.nixos.org/nixpkgs-unstable

nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager

nix-channel --update


# Source $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh in bash