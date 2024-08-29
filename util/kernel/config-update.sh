#!/bin/bash

#if [[ $EUID -ne 0 ]]; then
#	echo "This script must be run with root/sudo privileges."
#	exit 1
#fi

if [ $# -ne 2 ]; then
	echo "Usage: <file_name> <config_value>"
	exit 1
fi
conf_file=$1
shift

KEY=$(echo "$1" | cut -d'=' -f1)
VALUE=$(echo "$1" | cut -d'=' -f2)

if [[ -z "$KEY" || -z "$VALUE" ]]; then
    echo "Invalid key-value pair. Please provide a valid key-value pair."
    exit 1
fi

if ! [[ "$1" == *"="* ]]; then
    echo "Invalid key-value pair. Please provide a key-value pair in the format 'key=value'."
    exit 1
fi

if grep -q "^$KEY=" $conf_file; then
    sed -i "s|^$KEY=.*|$KEY=$VALUE|" $conf_file
elif grep -q "^$KEY =" $conf_file; then
    sed -i "s|^$KEY =.*|$KEY = $VALUE|" $conf_file
else
    echo "$KEY=$VALUE" >> $conf_file
fi
