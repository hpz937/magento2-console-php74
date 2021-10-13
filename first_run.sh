#!/bin/bash

useradd -d /srv/magento -M -s /bin/zsh -G www-data magento
PASSWORD=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w10 | head -n 1)
echo "'magento' user password is: $PASSWORD"
echo "magento:$PASSWORD" | chpasswd
mkdir /srv/magento/.ssh
chmod 700 /srv/magento/.ssh/
chown magento:www-data -R /srv/magento
runuser -l magento -c 'sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"'
