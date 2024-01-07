#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi
CUR_USER=$(whoami)

echo "export JAVA_HOME=\"/usr/lib/jvm/java-11-openjdk-amd64\"" >> /home/$CUR_USER/.bashrc