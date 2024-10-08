#!/bin/bash

if [[ $EUID -ne 0 ]]; then
        echo "This script must be run as root" 1>&2
        exit 1
fi


apt update
#install auto-apt-proxy asap to make sure the rest goes through the proxy
apt install -y auto-apt-proxy
echo APT Proxy:
auto-apt-proxy


apt upgrade -y
apt install -y iputils-ping dnsutils clamav clamav-daemon nano ufw 

Echo Updating Antivirus
systemctl stop clamav-freshclam
freshclam
sudo systemctl start clamav-freshclam

echo Enabling Firewall
ufw allow ssh
echo y | ufw enable


echo Adding IP to pre-login banner.
echo IP: \\4 >>  /etc/issue