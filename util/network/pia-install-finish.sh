#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
        echo "This script should not be run with root/sudo privileges."
        exit 1
fi

CUR_USER=$(whoami)

chmod +x /home/$CUR_USER/scripts/pia-ip/ipcheck.sh
chmod +x /home/$CUR_USER/scripts/pia-ip/pia-fwd.sh
chmod +x /home/$CUR_USER/scripts/pia-ip/pia-port-detect.sh
chmod +x /home/$CUR_USER/scripts/pia-ip/pia-reconnect.sh
chmod +x /home/$CUR_USER/scripts/pia-ip/pia-report.sh

echo "@reboot /home/$CUR_USER/scripts/pia-ip/ipcheck.sh" >> /tmp/pia-cron
echo "@reboot /home/$CUR_USER/scripts/pia-ip/pia-port-detect.sh" >> /tmp/pia-cron
echo "5 5 * * * /home/$CUR_USER/scripts/pia-ip/pia-reconnect.sh 30" >> /tmp/pia-cron
echo "25 5 * * * /home/$CUR_USER/scripts/pia-ip/pia-report.sh" >> /tmp/pia-cron
echo "35 5 * * * /home/$CUR_USER/scripts/pia-ip/pia-fwd.sh 22" >> /tmp/pia-cron

crontab /tmp/pia-cron

sudo -k cp /home/$CUR_USER/scripts/pia-ip/pia-fwd.sh /usr/bin/pia-fwd
sudo chmod +x /usr/bin/pia-fwd

sudo cp /home/$CUR_USER/scripts/pia-ip/pia-reconnect.sh /usr/bin/pia-reconnect
sudo chmod +x /usr/bin/pia-reconnect
