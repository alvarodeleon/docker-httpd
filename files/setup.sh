#!/bin/bash
# File              : setup.sh
# Author            : Alvaro <alvaro@server.com.uy>
# Date              : 26.11.2020
# Last Modified Date: 26.11.2020
# Last Modified By  : Alvaro <alvaro@server.com.uy>
yum -y --setopt=tsflags=nodocs update && \
    yum clean all

yum install -y initscripts

#Instalamos este repositior
yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum install -y epel-release
 
#Actualizamos el sistema
yum update -y
 
#Opcional: En lo personal instalo todos estas herramientas y 
#liberias porque siempre suelo utilizarlas
yum install -y wget nano lynx git iputils net-tools nmap mtr gcc gcc-c++ make autoconf glibc rcs pcre-devel openssl-devel expat-devel geoip-devel zlib-devel mlocate ncdu mytop composer npm bind-utils
 
yum install yum-utils -y
 
#Instalamos Nginx, MariaDB y SSH
yum install -y httpd nginx mariadb-server openssh-server mod_fcgid mod_ssl

yum install -y postgresql-server postgresql postgresql-contrib
 
#Con esto instalaremos PHP 5.4, 5.5, 5.6, 7.0, 7.1, 7.2 y 7.3 
#ademas de todas las librerías necesarias mas PHP-FPM para
#cada versión de PHP anterior
yum install -y php54 php55 php56 php70 php71 php72 php73 php80 \
php54-php-fpm php55-php-fpm php56-php-fpm php70-php-fpm php71-php-fpm php72-php-fpm php73-php-fpm php80-php-fpm \
php54-php-mysql php54-php-mcrypt php54-php-mbstring php54-php-cli php54-php-fpm php54-php-gd php54-php-json php54-php-ioncube-loader php54-php-intl php54-php-pdo php54-php-pgsql php54-php-soap php54-php-xml php54-php-xmlrpc \
php55-php-mysql php55-php-mcrypt php55-php-mbstring php55-php-cli php55-php-fpm php55-php-gd php55-php-json php55-php-ioncube-loader php55-php-intl php55-php-pdo php55-php-pgsql php55-php-soap php55-php-xml php55-php-xmlrpc \
php56-php-mysql php56-php-mcrypt php56-php-mbstring php56-php-cli php56-php-fpm php56-php-gd php56-php-json php56-php-ioncube-loader php56-php-intl php56-php-pdo php56-php-pgsql php56-php-soap php56-php-xml php56-php-xmlrpc \
php70-php-mysql php70-php-mcrypt php70-php-mbstring php70-php-cli php70-php-fpm php70-php-gd php70-php-json php70-php-ioncube-loader php70-php-intl php70-php-pdo php70-php-pgsql php70-php-soap php70-php-xml php70-php-xmlrpc \
php71-php-mysql php71-php-mcrypt php71-php-mbstring php71-php-cli php71-php-fpm php71-php-gd php71-php-json php71-php-ioncube-loader php71-php-intl php71-php-pdo php71-php-pgsql php71-php-soap php71-php-xml php71-php-xmlrpc \
php72-php-mysql php72-php-mcrypt php72-php-mbstring php72-php-cli php72-php-fpm php72-php-gd php72-php-json php72-php-ioncube-loader php72-php-intl php72-php-pdo php72-php-pgsql php72-php-soap php72-php-xml php72-php-xmlrpc \
php73-php-mysql php73-php-mcrypt php73-php-mbstring php73-php-cli php73-php-fpm php73-php-gd php73-php-json php73-php-ioncube-loader php73-php-intl php73-php-pdo php73-php-pgsql php73-php-soap php73-php-xml php73-php-xmlrpc \
php73-php-mysql php73-php-mcrypt php73-php-mbstring php73-php-cli php73-php-fpm php73-php-gd php73-php-json php73-php-ioncube-loader php73-php-intl php73-php-pdo php73-php-pgsql php73-php-soap php73-php-xml php73-php-xmlrpc \
php74-php-mysql php74-php-mcrypt php74-php-mbstring php74-php-cli php74-php-fpm php74-php-gd php74-php-json php74-php-ioncube-loader php74-php-intl php74-php-pdo php74-php-pgsql php74-php-soap php74-php-xml php74-php-xmlrpc \
php80-php-mysqlnd php80-php-common php80-php-mbstring php80-php-cli php80-php-fpm php80-php-gd php80-php-json php80-php-ioncube-loader php80-php-intl php80-php-pdo php80-php-pgsql php80-php-soap php80-php-xml php80-php-pecl-xmlrpc

#Agregador sporte SSH2
yum install -y libssh2-devel php54-php-pecl-ssh2 php55-php-pecl-ssh2 php56-php-pecl-ssh2 php70-php-pecl-ssh2 php71-php-pecl-ssh2 php72-php-pecl-ssh2 php73-php-pecl-ssh2 php74-php-pecl-ssh2 php80-php-pecl-ssh2


yum -y install python2-pip python34 python34-pip python36 python36-pip
yum -y install phpmyadmin


#
echo "extension=ssh2.so" >> /opt/remi/php54/root/etc/php.ini
echo "extension=ssh2.so" >> /opt/remi/php55/root/etc/php.ini
echo "extension=ssh2.so" >> /opt/remi/php56/root/etc/php.ini
echo "extension=ssh2.so" >> /opt/remi/php56/root/etc/php.ini
echo "extension=ssh2.so" >> /etc/opt/remi/php70/php.ini
echo "extension=ssh2.so" >> /etc/opt/remi/php71/php.ini
echo "extension=ssh2.so" >> /etc/opt/remi/php72/php.ini
echo "extension=ssh2.so" >> /etc/opt/remi/php73/php.ini
echo "extension=ssh2.so" >> /etc/opt/remi/php74/php.ini
echo "extension=ssh2.so" >> /etc/opt/remi/php80/php.ini

adduser www-data

#Cambiando usuario de Apache
sed -i 's/User apache/User www-data/g' /etc/httpd/conf/httpd.conf 
sed -i 's/Group apache/Group www-data/g' /etc/httpd/conf/httpd.conf 

#Habilitando AllowOverride
sed -i 's/    AllowOverride None/    AllowOverride All/g' /etc/httpd/conf/httpd.conf 

#Cambiando usuario de Nginx
sed -i 's/user nginx;/user nginx;/g' /etc/nginx/nginx.conf 

#Carpeta de configuracion de sitios Apache
echo "IncludeOptional sites.d/*.conf" >> /etc/httpd/conf/httpd.conf
 

#A cada version de PHP-FPM le asignamos un
#puerto diferente mediante los siguientes comandos
sed -i 's/:9000/:9054/' /opt/remi/php54/root/etc/php-fpm.d/www.conf
sed -i 's/:9000/:9055/' /opt/remi/php55/root/etc/php-fpm.d/www.conf
sed -i 's/:9000/:9056/' /etc/opt/remi/php56/php-fpm.d/www.conf
sed -i 's/:9000/:9070/' /etc/opt/remi/php70/php-fpm.d/www.conf
sed -i 's/:9000/:9071/' /etc/opt/remi/php71/php-fpm.d/www.conf
sed -i 's/:9000/:9072/' /etc/opt/remi/php72/php-fpm.d/www.conf
sed -i 's/:9000/:9073/' /etc/opt/remi/php73/php-fpm.d/www.conf
sed -i 's/:9000/:9074/' /etc/opt/remi/php74/php-fpm.d/www.conf
sed -i 's/:9000/:9080/' /etc/opt/remi/php80/php-fpm.d/www.conf
 
#Cambiando usuario de PHP-FPM
sed -i 's/user = apache/user = www-data/' /opt/remi/php54/root/etc/php-fpm.d/www.conf
sed -i 's/group = apache/group = www-data/' /opt/remi/php54/root/etc/php-fpm.d/www.conf
sed -i 's/user = apache/user = www-data/' /opt/remi/php55/root/etc/php-fpm.d/www.conf
sed -i 's/group = apache/group = www-data/' /opt/remi/php55/root/etc/php-fpm.d/www.conf
sed -i 's/user = apache/user = www-data/' /etc/opt/remi/php56/php-fpm.d/www.conf
sed -i 's/group = apache/group = www-data/' /etc/opt/remi/php56/php-fpm.d/www.conf
sed -i 's/user = apache/user = www-data/' /etc/opt/remi/php70/php-fpm.d/www.conf
sed -i 's/group = apache/group = www-data/' /etc/opt/remi/php70/php-fpm.d/www.conf
sed -i 's/user = apache/user = www-data/' /etc/opt/remi/php71/php-fpm.d/www.conf
sed -i 's/group = apache/group = www-data/' /etc/opt/remi/php71/php-fpm.d/www.conf
sed -i 's/user = apache/user = www-data/' /etc/opt/remi/php72/php-fpm.d/www.conf
sed -i 's/group = apache/group = www-data/' /etc/opt/remi/php72/php-fpm.d/www.conf
sed -i 's/user = apache/user = www-data/' /etc/opt/remi/php73/php-fpm.d/www.conf
sed -i 's/group = apache/group = www-data/' /etc/opt/remi/php73/php-fpm.d/www.conf
sed -i 's/user = apache/user = www-data/' /etc/opt/remi/php74/php-fpm.d/www.conf
sed -i 's/group = apache/group = www-data/' /etc/opt/remi/php74/php-fpm.d/www.conf
sed -i 's/user = apache/user = www-data/' /etc/opt/remi/php80/php-fpm.d/www.conf
sed -i 's/group = apache/group = www-data/' /etc/opt/remi/php80/php-fpm.d/www.conf

#Cambiamos propietraios y grupos
chown www-data /opt/remi/php54/root/var/log/php-fpm
chown www-data /opt/remi/php55/root/var/log/php-fpm
chown www-data /opt/remi/php56/root/var/log/php-fpm
chown www-data /var/opt/remi/php70/log/php-fpm
chown www-data /var/opt/remi/php71/log/php-fpm
chown www-data /var/opt/remi/php72/log/php-fpm
chown www-data /var/opt/remi/php73/log/php-fpm
chown www-data /var/opt/remi/php74/log/php-fpm
chown www-data /var/opt/remi/php80/log/php-fpm

chgrp www-data -R /opt/remi/php54/root/var/lib/php/wsdlcache
chgrp www-data -R /opt/remi/php56/root/var/lib/php/wsdlcache
chgrp www-data -R /opt/remi/php55/root/var/lib/php/wsdlcache
chgrp www-data -R /var/opt/remi/php70/lib/php/wsdlcache
chgrp www-data -R /var/opt/remi/php70/lib/php/opcache
chgrp www-data -R /var/opt/remi/php72/lib/php/wsdlcache
chgrp www-data -R /var/opt/remi/php72/lib/php/opcache
chgrp www-data -R /var/opt/remi/php71/lib/php/wsdlcache
chgrp www-data -R /var/opt/remi/php71/lib/php/opcache
chgrp www-data -R /var/opt/remi/php73/lib/php/wsdlcache
chgrp www-data -R /var/opt/remi/php73/lib/php/opcache
chgrp www-data -R /var/opt/remi/php74/lib/php/wsdlcache
chgrp www-data -R /var/opt/remi/php74/lib/php/opcache
chgrp www-data -R /var/opt/remi/php80/lib/php/wsdlcache
chgrp www-data -R /var/opt/remi/php80/lib/php/opcache

chown www-data:www-data /opt/remi/php54/root/var/lib/php/session
chown www-data:www-data /opt/remi/php55/root/var/lib/php/session
chown www-data:www-data /var/opt/remi/php56/lib/php/session
chown www-data:www-data /var/opt/remi/php70/lib/php/session
chown www-data:www-data /var/opt/remi/php71/lib/php/session
chown www-data:www-data /var/opt/remi/php72/lib/php/session
chown www-data:www-data /var/opt/remi/php73/lib/php/session
chown www-data:www-data /var/opt/remi/php80/lib/php/session

sed -i 's/PrivateTmp=true/PrivateTmp=false/g' /usr/lib/systemd/system/php54-php-fpm.service
sed -i 's/PrivateTmp=true/PrivateTmp=false/g' /usr/lib/systemd/system/php55-php-fpm.service
sed -i 's/PrivateTmp=true/PrivateTmp=false/g' /usr/lib/systemd/system/php56-php-fpm.service
sed -i 's/PrivateTmp=true/PrivateTmp=false/g' /usr/lib/systemd/system/php70-php-fpm.service
sed -i 's/PrivateTmp=true/PrivateTmp=false/g' /usr/lib/systemd/system/php71-php-fpm.service
sed -i 's/PrivateTmp=true/PrivateTmp=false/g' /usr/lib/systemd/system/php72-php-fpm.service
sed -i 's/PrivateTmp=true/PrivateTmp=false/g' /usr/lib/systemd/system/php73-php-fpm.service
sed -i 's/PrivateTmp=true/PrivateTmp=false/g' /usr/lib/systemd/system/php80-php-fpm.service


mkdir -p /etc/ssl/
openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout /etc/ssl/apache-selfsigned.key -out /etc/ssl/apache-selfsigned.crt -subj "/C=UY/ST=Maldonado/L=Maldonado/O=Testing/OU=Testing/CN=example.lan"

echo -en "\033[1;31m" >> /etc/issue
echo "Default" >> /etc/issue

echo "System" >> /etc/issue
echo "User: root" >> /etc/issue
echo "Password: docker" >> /etc/issue
echo "" >> /etc/issue
echo "MySQL: " >> /etc/issue
echo "User: root" >> /etc/issue
echo "Password: empty" >> /etc/issue
echo "" >> /etc/issue
echo "phpMyAdmin: " >> /etc/issue
echo "User: dbroot" >> /etc/issue
echo "Password: dbroot" >> /etc/issue
echo "" >> /etc/issue

echo "If MySQL fail on boot and /var/lib/mysql is empty, please execute mysql_repair" >> /etc/issue
echo "" >> /etc/issue
echo "For more instruction: https://www.alvarodeleon.net/entorno-de-desarrollo-apache-nginx-en-docker/" >> /etc/issue
echo "" >> /etc/issue

echo -en "\033[0m" >> /etc/issue





