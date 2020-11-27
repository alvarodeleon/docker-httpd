#!/bin/bash

yum install -y php80 
php80-php-fpm \
php80-php-mysqlnd php80-php-common php80-php-mbstring php80-php-cli php80-php-fpm php80-php-gd php80-php-json php80-php-ioncube-loader php80-php-intl php80-php-pdo php80-php-pgsql php80-php-soap php80-php-xml php80-php-pecl-xmlrpc

yum install -y php80-php-pecl-ssh2

echo "extension=ssh2.so" >> /etc/opt/remi/php80/php.ini

sed -i 's/:9000/:9080/' /etc/opt/remi/php80/php-fpm.d/www.conf

sed -i 's/user = apache/user = www-data/' /etc/opt/remi/php80/php-fpm.d/www.conf
sed -i 's/group = apache/group = www-data/' /etc/opt/remi/php80/php-fpm.d/www.conf

chown www-data /var/opt/remi/php80/log/php-fpm

chgrp www-data -R /var/opt/remi/php80/lib/php/wsdlcache
chgrp www-data -R /var/opt/remi/php80/lib/php/opcache

chown www-data:www-data /var/opt/remi/php73/lib/php/session
chown www-data:www-data /var/opt/remi/php80/lib/php/session

sed -i 's/PrivateTmp=true/PrivateTmp=false/g' /usr/lib/systemd/system/php80-php-fpm.service

/bin/systemctl enable php80-php-fpm
/bin/systemctl start php80-php-fpm

