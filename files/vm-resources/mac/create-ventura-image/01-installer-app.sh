#!/bin/bash

SOURCE="https://mrmacintosh.com/macos-ventura-13-full-installer-database-download-directly-from-apple/"
# FILE="https://swcdn.apple.com/content/downloads/36/06/042-01917-A_B57IOY75IU/oocuh8ap7y8l8vhu6ria5aqk7edd262orj/InstallAssistant.pkg"

echo "Downloading latest file. If the script fails to download the right file, download manually from"
echo "$SOURCE"

mkdir -p ~/installers/ventura

curl $SOURCE > ~/installers/ventura/site.html

link=$(cat ~/installers/ventura/site.html | grep "apple.com/content" | head -1)
link=$(echo "$link" | grep -o 'href="[^"]*"')
link=${link#href=\"}
link=${link%\"}

echo "Beginning Download"

wget -O ~/installers/ventura/InstallAssistant.pkg $link

mkdir -p ~/Downloads/Ventura
mv ~/installers/ventura/InstallAssistant.pkg ~/Downloads/Ventura/InstallAssistant.pkg

echo "InstallAssistant.pkg downloaded into ~/Downloads/Ventura/InstallAssistant.pkg"
echo "Run the file to create the 'Install macOS Ventura.app' in your Applications folder"
echo "Then, run ./02-create-img.sh to create the ventura image"