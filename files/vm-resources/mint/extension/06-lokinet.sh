#!/bin/bash

VERSION="v0.9.10"

if ! [[ $EUID -ne 0 ]]; then
	echo "This script must not be run with root/sudo privileges."
	exit 1
fi

# Build/install the executables
sudo chmod 777 /opt
#git clone --recursive https://github.com/oxen-io/lokinet /opt/lokinet
git clone --recursive --branch $VERSION https://github.com/oxen-io/lokinet /opt/lokinet
cd /opt/lokinet
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF
make -j$(nproc)

sudo make install

# Setup initial configs
sudo lokinet -g
sudo lokinet-bootstrap


# Configure DNS
# Configure Autostart
# Configure KillSwitch
