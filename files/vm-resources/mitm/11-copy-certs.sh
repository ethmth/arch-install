#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi
CUR_USER=$(whoami)

if ! [ -d "/home/$CUR_USER/.mitmproxy" ]; then
	echo "/home/$CUR_USER/.mitmproxy not found. Please run mitm and then try again"
	exit 1
fi

if ! [ -d "/home/$CUR_USER/share" ]; then
	echo "/home/$CUR_USER/share not found. Please configure the shared folder and then try again"
	exit 1
fi

openssl x509 -inform PEM -outform DER -in /home/$CUR_USER/.mitmproxy/mitmproxy-ca-cert.pem -out /home/$CUR_USER/.mitmproxy/mitmproxy-ca-cert.crt

cp -r /home/$CUR_USER/.mitmproxy /home/$CUR_USER/share/

ls -al /home/$CUR_USER/share/
ls -al /home/$CUR_USER/share/.mitmproxy