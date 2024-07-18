#!/bin/bash
sudo apt update -y 
sudo apt install nginx -y 
echo "<h1>Hellow, This is Test Web Page Hosted on the server $(hostname -f). </h1>" > /var/www/html/index.html
echo "<h1> Thanks To Visit </h1>" >> /var/www/html/index.html





