#!/bin/bash

# Instalação do Apache e PHP
sudo apt-get update
sudo apt-get install apache2 -y
sudo apt-get install php7.2 php7.2-curl php7.2-gd php7.2-imap php7.2-json php7.2-mbstring php7.2-mysqli php7.2-pdo_mysql php7.2-xml php7.2-zip -y

# Instalação do MySQL
sudo apt-get install mysql-server -y

# Download do iTop
cd /var/www/html
sudo wget https://downloads.sourceforge.net/project/itop/itop/2.8.0/iTop-2.8.0-3563.zip
sudo unzip iTop-2.8.0-3563.zip
sudo mv itop/ /var/www/html/
sudo chown -R www-data:www-data /var/www/html/itop

# Configuração do MySQL
sudo mysql -u root -p <<EOF
CREATE DATABASE itop;
CREATE USER 'itopuser'@'localhost' IDENTIFIED BY 'itoppassword';
GRANT ALL PRIVILEGES ON itop.* TO 'itopuser'@'localhost';
FLUSH PRIVILEGES;
EOF

# Configuração do iTop
cd /var/www/html/itop/conf
sudo cp config-itop.php-dist config-itop.php
sudo sed -i 's/root/itopuser/g' config-itop.php
sudo sed -i 's/localhost/127.0.0.1/g' config-itop.php
sudo sed -i 's/\'\'/\'itoppassword\'/g' config-itop.php

# Reiniciar Apache
sudo systemctl restart apache2.service
