#!/bin/bash

if [[ $EUID -ne 0 ]]; then
	echo "This script should be run with root/sudo privileges."
	exit 1
fi

read -p "Enter your username on the Wireguard machine: " username

mkdir -p /opt/wireguard-client
chmod -R 777 /opt/wireguard-client

scp -r $username@10.152.152.15:/opt/wireguard-server/config/peer2 /opt/wireguard-client

if ! [ -e "/opt/wireguard-client/peer2/peer2.conf" ]; then
	echo "Make sure you have created peer2 on the $username machine"
	exit 1
fi

chmod -R 777 /opt/wireguard-client


PRIVATE_KEY=$(cat /opt/wireguard-client/peer2/peer2.conf | grep "PrivateKey" | cut -d '=' -f 2- | sed -e 's/^[[:space:]]*//')
PUBLIC_KEY=$(cat /opt/wireguard-client/peer2/peer2.conf | grep "PublicKey" | cut -d '=' -f 2- | sed -e 's/^[[:space:]]*//')
PRESHARED_KEY=$(cat /opt/wireguard-client/peer2/peer2.conf | grep "PresharedKey" | cut -d '=' -f 2- | sed -e 's/^[[:space:]]*//')

string_to_echo=$(echo "  networking.wg-quick.interfaces = {
    wg0 = {
      address = [ \"10.13.13.3\" ];
      dns = [ \"10.152.152.10\" ];
      privateKey = \"$PRIVATE_KEY\";
      
      peers = [
        {
          publicKey = \"$PUBLIC_KEY\";
          presharedKey = \"$PRESHARED_KEY\";
          allowedIPs = [ \"10.13.13.0/24\" ];
          endpoint = \"10.152.152.15:51820\";
          persistentKeepalive = 25;
        }
      ];
    };
  };")

search_string="ADD_WIREGUARD_SECTION_HERE"
file="/etc/nixos/configuration.nix"
tmp_file="/tmp/configuration.nix"

cp $file $tmp_file
printf "" > $file

while IFS= read -r line; do
  echo "$line" >> "$file"
  if [[ $line == *"$search_string"* ]]; then
    echo "$string_to_echo" >> "$file"
  fi
done < "$tmp_file"

rm $tmp_file

rm -rf /opt/wireguard-client

nixos-rebuild switch

echo "Restart, then run ./06-wireguard-finish.sh"
