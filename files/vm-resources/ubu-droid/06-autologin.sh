 #!/bin/bash

if [[ $EUID -ne 0 ]]; then
        echo "This script should be run with root/sudo privileges."
        exit 1
fi

mkdir -p /etc/systemd/system/getty@tty1.service.d
 
cat > /etc/systemd/system/getty@tty1.service.d/override.conf <<- "_EOF_"
[Service]
ExecStart=
ExecStart=-/sbin/mingetty --autologin android --noclear tty1
_EOF_

systemctl enable getty@tty1.service

echo 'if [ "$WAYLAND_DISPLAY" == "" ]; then' >> /home/android/.bashrc
echo 'weston' >> /home/android/.bashrc
echo 'fi' >> /home/android/.bashrc