#!/bin/sh

mkdir -p ~/.termux/boot

echo "#!/data/data/com.termux/files/usr/bin/sh" > ~/.termux/boot/start-sshd
echo "termux-wake-lock" >> ~/.termux/boot/start-sshd
echo "sshd" >> ~/.termux/boot/start-sshd