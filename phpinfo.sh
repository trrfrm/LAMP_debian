#!/bin/bash
sudo apt update
sudo apt install apache2 -y
sudo systemctl start apache2
sudo systemctl enable apache2
sudo apt install php libapache2-mod-php -y
echo '<?php phpinfo();?>' > info.php
sudo cp info.php /var/www/html/
sudo systemctl restart apache2
