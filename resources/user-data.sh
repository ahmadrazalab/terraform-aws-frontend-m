#!/bin/bash
sudo apt update -y 
sudo apt install nginx -y 
echo "<h1>Hellow, This is Test Web Page Hosted on the server $(hostname -f). </h1>" > /var/www/html/index.html
echo "<h1> Thanks To Visit </h1>" >> /var/www/html/index.html





# #!/bin/bash
# # Update and install Apache and PHP
# sudo apt-get update -y
# sudo apt-get install -y apache2 php libapache2-mod-php

# # Create the directory for the webpage
# sudo mkdir -p /var/www/html

# # Create the db_check.php file
# cat << 'EOF' > /var/www/html/db_check.php
# <?php
# $servername = "your_db_server";
# $username = "your_db_username";
# $password = "your_db_password";
# $dbname = "your_db_name";

# // Create connection
# $conn = new mysqli($servername, $username, $password, $dbname);

# // Check connection
# if ($conn->connect_error) {
#     die("Connection failed: " . $conn->connect_error);
# } 
# echo "Connected successfully";
# ?>
# EOF

# # Set permissions
# sudo chown -R www-data:www-data /var/www/html
# sudo chmod -R 755 /var/www/html

# # Restart Apache to apply changes
# sudo systemctl restart apache2
