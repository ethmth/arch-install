#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
	echo "This script must be run with root/sudo privileges."
	exit 1
fi

read -p "Please enter your email address: " email
if [ "$email" == "" ]; then
  echo "Eamil cannot be empty"
  exit 1
fi

if ! ( [ -f "/etc/mdadm.conf" ] && ( cat "/etc/mdadm.conf" | grep -q '^PROGRAM' ) ); then
    echo "PROGRAM /usr/local/bin/mdadm-notify" >> /etc/mdadm.conf
fi

if ! ( [ -f "/etc/mdadm.conf" ] && ( cat "/etc/mdadm.conf" | grep -q '^MAILADDR' ) ); then
    echo "MAILADDR $email" >> /etc/mdadm.conf
else
	echo "MAILADDR already exists in /etc/mdadm.conf. Remove it to continue."
	exit 1
fi



echo "You may need to edit ~/.msmtprc if the mailserver there is incorrect."