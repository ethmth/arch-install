#!/bin/bash

if [[ $EUID -ne 0 ]]; then
	echo "This script must be run with root/sudo privileges."
	exit 1
fi

output=$(dkms status -m 8812au)

driver=$(echo "$output" | sed 's/\s\+/\n/g' | grep "8812" | sed 's/,*$//g' | head -n 1)

kernels=$(echo "$output" | grep "$driver" | cut -d ',' -f 2)

while IFS= read -r line; do
    kernel=$(echo "$line" | tr -d '[:space:]')
    echo "dkms remove $driver -k $kernel"
    dkms remove $driver -k $kernel
done <<< "$kernels"
