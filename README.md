# Entorno de desarrollo Apache/Nginx en Docker

[Sitio Web del Proyecto](https://www.alvarodeleon.net/entorno-de-desarrollo-apache-nginx-en-docker/)

## Descargando
Lo primero que debemos hacer es descargar el repositorio con el Dockerfile y todos los archivos necestarios, eso lo podemos hacer de la siguiente forma:
```
cd /tmp/

git clone https://github.com/alvarodeleon/docker-httpd.git

cd docker-httpd
```

## Construyendo a imagen
Para construir la imágenes solo necesitamos correr el comando bulid que generara la imagen base del contenedor, este proceso puede demorar un largo largo dato dependiendo de la velocidad de conexión y el rendimiento del pc donde corra
```
sh ./build
```
El comando build iniciara la creación de la imagen para lo cual descargara un par de GB desde los repositorios de CentOS asi que no lo corran usando datos moviles o similar, están avisados.

## Creando el contenedor

###Comando create
Junto con los archivos de creación de la imagen se añadio un script para crear automáticamente el contenedor con un nombre determinado en una ruta con la estructura
```
sh ./create NombreContenedor /ruta/proyecto/
docker start NombreContenedor && docker attach NombreContenedor
```
### Reparando Base De Datos
Como el almacén da datos de MySQL esta ubicado fuera del contenedor al iniciar no va a exitir los archivos y en caso que existan va a ser necesario reparar los permisos para que el servidor funcione correctamente, eso lo podemos hacer fácilmente con el comando:
```
mysql_repair
```
### Seleccionando servidor web Apache O Nginx
Por defecto vienen instalados tanto Nginx como Apache, ambos deshabilitados para que seleccionemos el que mas nos interesa, para eso simplemente ejecutamos:

#### Apache
```
systemctl enable httpd
systemctl start httpd
```

#### Nginx
```
systemctl enable nginx
systemctl start nginx
```
## Directorios
En la carpeta del proyecto /ruta/proyecto/ encontraremos diferentes carpetas

1. **apache** Aquí se colocaran los archivos de configuración de Apache de cada sitio, dentro del contenedor apunta a /etc/httpd/sites.d/
2. **nginx** Aquí se colocaran los archivos de configuración de Ngnix de cada sitio dentro del contenedor apunta a /etc/nginx/conf.d/
3. **html** Es la carpeta donde se almacenan los proyectos, dentro del contenedor apunta a /var/www/html/
4. **backup** Dentro del contenedor apunta /mnt/backup/ permite generar backup fuera del contendor
5. **disk** Dentro del contenedor apunta /mnt/disk/ permite compartir archivos entre el contenedor y el pc
6. **mysql** Es la carpeta donde físicamente se almacena, queda por fuera del contenedor para poder utilizar los mismos datos entre diferentes contenedores

## Crear un Virtualhost sitio con PHP en Apache
Dentro del directorio apache (es decir /ruta/proyecto/apache) en el pc anfitiron creamos un archivo que debe terminar en .conf , por ejemplo example.com.conf y agregamos el siguiente contenido:
```
<VirtualHost *:80>

	ServerName example.com
	ServerAlias www.example.com

	DocumentRoot "/var/www/html/example.com/"
	DirectoryIndex index.php index.phtml index.html index.htm

	<FilesMatch \.php$>
		SetHandler "proxy:fcgi://127.0.0.1:9073"
	</FilesMatch>
</VirtualHost>
```
Luego para cambiar la version de PHP simplemente modificamos la linea por la que necesitemos:
```
SetHandler "proxy:fcgi://127.0.0.1:9073"
```
Las versiones disponibles son:
```
#PHP 5.4
SetHandler "proxy:fcgi://127.0.0.1:9054"

#PHP 5.5
SetHandler "proxy:fcgi://127.0.0.1:9055"

#PHP 5.6
SetHandler "proxy:fcgi://127.0.0.1:9056"

#PHP 7.0
SetHandler "proxy:fcgi://127.0.0.1:9070"

#PHP 7.1
SetHandler "proxy:fcgi://127.0.0.1:9071"

#PHP 7.2
SetHandler "proxy:fcgi://127.0.0.1:9072"

#PHP 7.3
SetHandler "proxy:fcgi://127.0.0.1:9073"

#PHP 7.4
SetHandler "proxy:fcgi://127.0.0.1:9074"

#PHP 8.0
SetHandler "proxy:fcgi://127.0.0.1:9080"

```
Luego de creado y ajustado la versión de PHP que se necesites ejecutamos:
```
service httpd restart
```

## Crear un virtualhost sitio con PHP en Nginx
Para el caso de crear un virtualhost para Nginx, es similar, solo que esta vez el fichero va en el directorio nginx en por ejemplo /ruta/proyecto/nginx y dentro colocaremos un fichero .conf por ejemplo example.com.conf
```
server {

	listen 80;
	listen [::]:80;

	server_name example.com;

	root /var/www/html/example.com;
	
	index index.php index.html index.htm index.nginx-debian.html;

	location / {
		try_files $uri $uri/ =404;
	}

	location ~ \.php$ {
		try_files $uri =404;

		#Version de PHP
		fastcgi_pass 127.0.0.1:9073;

	fastcgi_index index.php;
	fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
	include fastcgi_params;
	fastcgi_buffer_size 128k;
	fastcgi_buffers 256 4k;
	fastcgi_busy_buffers_size 256k;
	fastcgi_temp_file_write_size 256k;

	#php.ini
	fastcgi_param PHP_VALUE "
		memory_limit=512M;
		upload_max_filesize=64M;
		post_max_size=64M;
		max_input_vars=10000;
		max_execution_time=120;
		max_input_time=120;
		error_reporting=E_ALL;
	";
	}

	location ~ /\.ht {
		deny all;
	}
}
```
Al igual que en el caso de Apache, ahora con Nginx también bastara una linea para ajustar la versión de PHP deseada:
```
#PHP 5.4
fastcgi_pass 127.0.0.1:9054;

#PHP 5.5
fastcgi_pass 127.0.0.1:9055;

#PHP 5.6
fastcgi_pass 127.0.0.1:9056;

#PHP 7.0
fastcgi_pass 127.0.0.1:9070;

#PHP 7.1
fastcgi_pass 127.0.0.1:9071;

#PHP 7.2
fastcgi_pass 127.0.0.1:9072;

#PHP 7.3
fastcgi_pass 127.0.0.1:9073;

#PHP 7.4
fastcgi_pass 127.0.0.1:9074;

#PHP 8.0
fastcgi_pass 127.0.0.1:9080;
```
Luego de creado y ajustado la versión de PHP que se necesites ejecutamos:
```
service httpd restart
```

