
FROM centos:7
MAINTAINER The CentOS Project <deleon@adl.com.uy>
LABEL Vendor="alvarodeleon.net"

ADD files/setup.sh /setup.sh

RUN sh /setup.sh && rm -f /setup.sh

RUN echo "docker" | passwd root --stdin

ADD files/nginx/example.lan.conf /etc/nginx/conf.d.example/example.lan.conf
ADD files/nginx/node.lan.conf /etc/nginx/conf.d.example/node.lan.conf
ADD files/nginx/proxy_params /etc/nginx/conf.d.example/proxy_params
ADD files/nginx/phpmyadmin.conf /etc/nginx/conf.d.example/phpmyadmin.conf
ADD files/nginx/phppgadmin.conf /etc/nginx/conf.d.example/phppgadmin.conf
ADD files/apache/example.lan.conf /etc/httpd/conf.d.example/example.lan.conf

ADD files/cmd/mysql_repair /usr/sbin/mysql_repair
RUN chmod -v +x /usr/sbin/mysql_repair

ADD files/cmd/setphp /usr/sbin/setphp
RUN chmod -v +x /usr/sbin/setphp

ADD files/cmd/fixsessions /usr/sbin/fixsessions
RUN chmod -v +x /usr/sbin/fixsessions

ADD files/configure.sh /configure.sh
RUN chmod -v +x /configure.sh

RUN echo "@reboot sh /configure.sh" > /var/spool/cron/root
