#!/bin/bash

flatpaks="
net.sonic_pi.SonicPi
net.jami.Jami
"

flatpaks=${flatpaks//$'\n'/ }
flatpaks=$(echo "$flatpaks" | tr -s ' ' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
flatpak install flathub $flatpaks