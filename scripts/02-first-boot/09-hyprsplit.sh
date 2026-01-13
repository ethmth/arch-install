#!/usr/bin/env bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi

hyprpm update
hyprpm add https://github.com/shezdy/hyprsplit
hyprpm enable hyprsplit