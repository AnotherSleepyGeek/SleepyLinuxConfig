#!/bin/bash

if [[ $EUID -ne 0 ]]; then
        echo "This script must be run as root" 1>&2
        exit 1
fi


apt update
apt upgrade -y

apt install -y iputils-ping dnsutils clamav clamav-daemon nano ufw auto-apt-proxy

Echo Updating Antivirus
systemctl stop clamav-freshclam
freshclam
sudo systemctl start clamav-freshclam

echo Enabling Firewall
ufw allow ssh
echo y | ufw enable



#Copy my auhtorized key for authentication with ssh key
cp -f  ./authorized_keys  ~/.ssh/authorized_keys .

# Disable password authentication
SSH_CONFIG="/etc/ssh/sshd_config"
if grep -q "^#PasswordAuthentication yes" "$SSH_CONFIG"; then
   sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication no/' "$SSH_CONFIG"
else
   echo "PasswordAuthentication no" >> "$SSH_CONFIG"
fi


