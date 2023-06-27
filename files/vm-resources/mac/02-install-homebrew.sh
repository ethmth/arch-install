#!/bin/bash

mkdir -p ~/installers/brew

curl -fsSL -o ~/installers/brew/install.sh https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh

cd ~/installers/brew/

/bin/bash install.sh

echo "export PATH=/usr/local/bin:\$PATH" >> ~/.zshrc

source ~/.zshrc

brew doctor