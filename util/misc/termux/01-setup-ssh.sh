#!/bin/sh

# Install Termux, Termux:Boot, and Termux:API

pkg install openssl termux-api

pkg install openssh openssh-sftp-server

passwd

# ssh-keygen

sshd -D -e -ddd