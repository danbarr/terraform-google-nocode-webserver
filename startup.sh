#!/bin/bash

# Google Cloud startup scripts run on every boot unlike cloud-init user data scripts
if [[ -f /etc/startup_script_done ]]; then exit 0; fi

apt-get -qy update &&
    apt-get -qy -o "Dpkg::Options::=--force-confdef" -o "Dpkg::Options::=--force-confold" install nginx &&
    apt-get -qy clean

ufw allow 'Nginx HTTP'
chown -R ubuntu:ubuntu /var/www/html

touch /etc/startup_script_done