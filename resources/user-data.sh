#!/bin/bash
sudo apt update -y 
sudo apt install nginx -y 
echo "<h1>Hellow, This is Test Web Page Hosted on the server $(hostname -f). </h1>" > /var/www/html/index.html
echo "<h1> Thanks To Visit </h1>" >> /var/www/html/index.html



# setting up a php based application server 
sudo apt install net-tools -y 
timedatectl set-timezone Asia/Kolkata

# install php setup 
sudo apt update -y 
sudo apt upgrade -y 
# install php 8.1
sudo apt install software-properties-common -y 
sudo add-apt-repository ppa:ondrej/php
sudo apt update -y 
sudo apt install php8.2 -y 
sudo apt update -y  
sudo apt-get install -y  php8.2-fpm php8.2-cli php8.2-common php8.2-json php8.2-opcache php8.2-mysql php8.2-mbstring php8.2-xml php8.2-gd php8.2-curl
sudo systemctl restart php8.2-fpm
sudo apt install composer -y 
sudo snap install --classic certbot -y 



# cloning the repository to the server nginx path 

# composer install 
# .env update 


