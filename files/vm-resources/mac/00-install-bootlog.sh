#!/bin/bash

# echo "log show --last boot " > temp.sh
# sudo mv temp.sh /usr/bin/bootlog
# sudo chmod +x /usr/bin/bootlog

echo "alias bootlog='log show --last boot'" >> ~/.zshrc
source ~/.zshrc
