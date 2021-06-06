#!/bin/bash
# File              : configure.sh
# Author            : Alvaro <alvaro@server.com.uy>
# Date              : 26.11.2020
# Last Modified Date: 06.06.2021
# Last Modified By  : Alvaro <alvaro@server.com.uy>

echo "postgres  ALL=(ALL)	NOPASSWD:ALL" >> /etc/sudoers

/bin/systemctl stop mariadb 

/usr/sbin/mysql_repair

sudo su - postgres -c '/bin/postgresql-setup initdb'


/bin/systemctl start postgresql

#Set superuser
/bin/sudo -u postgres -i psql -c "ALTER USER postgres PASSWORD 'docker';"

#don't remove space
/bin/sed -i -E "s/local.*?all.*?all.*?peer/local   all             all                                     md5/g" /var/lib/pgsql/data/pg_hba.conf
/bin/sed -i -E "s/host.*?all.*?all.*?127.0.0.1\/32.*?ident/host    all             all             0.0.0.0\/0            md5/g" /var/lib/pgsql/data/pg_hba.conf


/bin/sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" /var/lib/pgsql/data/postgresql.conf

/bin/systemctl restart postgresql

if [ ! -d "/etc/httpd/sites.d/" ]; then
	mkdir -p /etc/httpd/sites.d/
fi

/bin/cp /etc/nginx/conf.d.example/phpmyadmin.conf /etc/nginx/conf.d/phpmyadmin.conf
/bin/cp /etc/nginx/conf.d.example/phppgadmin.conf /etc/nginx/conf.d/phppgadmin.conf

/bin/rm -f /usr/share/phpPgAdmin/conf/config.inc.php
/bin/cp -f /usr/share/phpPgAdmin/conf/config.inc.php-dist /usr/share/phpPgAdmin/conf/config.inc.php

/bin/sed -i "s/#primary_hostname =/primary_hostname = example.com/g" /etc/exim/exim.conf

/bin/sed -i "s/\$conf\['servers'\]\[0]\['host'\] = ''\;/\$conf['servers'][0]['host'] = 'localhost'\;/g" /usr/share/phpPgAdmin/conf/config.inc.php
/bin/sed -i "s/\$conf\['extra_login_security'\] = true\;/\$conf['extra_login_security'] = false;/g" /usr/share/phpPgAdmin/conf/config.inc.php

/bin/echo "* * * * * /usr/sbin/fixsessions" > /var/spool/cron/root

sh /usr/sbin/fixsessions

/bin/echo "export EDITOR=nano" >> /root/.bashrc
source /root/.bashrc

/bin/rm -fv  /etc/httpd/conf.d/phpMyAdmin.conf
/bin/rm -fv /etc/httpd/conf.d/phpPgAdmin.conf

if [ ! -f /etc/httpd/sites.d/phppgadmin.conf ]; then
	cp /etc/httpd/conf.d.example/phppgadmin.conf /etc/httpd/sites.d/phppgadmin.conf 
fi

if [ ! -f /etc/httpd/sites.d/phpmyadmin.conf ]; then
	cp /etc/httpd/conf.d.example/phpmyadmin.conf /etc/httpd/sites.d/phpmyadmin.conf
fi


#/bin/systemctl enable nginx
/bin/systemctl enable httpd
/bin/systemctl enable mariadb
/bin/systemctl enable postgresql
/bin/systemctl enable redis
/bin/systemctl enable exim
/bin/systemctl enable php54-php-fpm
/bin/systemctl enable php55-php-fpm
/bin/systemctl enable php56-php-fpm
/bin/systemctl enable php70-php-fpm
/bin/systemctl enable php71-php-fpm
/bin/systemctl enable php72-php-fpm
/bin/systemctl enable php73-php-fpm
/bin/systemctl enable php74-php-fpm
/bin/systemctl enable php80-php-fpm


#/bin/systemctl restart nginx
/bin/systemctl restart httpd
/bin/systemctl restart mariadb
/bin/systemctl restart postgresql
/bin/systemctl restart redis
/bin/systemctl restart exim
/bin/systemctl restart php54-php-fpm
/bin/systemctl restart php55-php-fpm
/bin/systemctl restart php56-php-fpm
/bin/systemctl restart php70-php-fpm
/bin/systemctl restart php71-php-fpm
/bin/systemctl restart php72-php-fpm
/bin/systemctl restart php73-php-fpm
/bin/systemctl restart php74-php-fpm
/bin/systemctl restart php80-php-fpm

/bin/rm -rf /configure.sh

#halt
