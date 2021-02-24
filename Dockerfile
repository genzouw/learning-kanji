FROM wordpress:5.6.2-php8.0-apache

RUN echo 'upload_max_filesize = 16M' >> /usr/local/etc/php/conf.d/php.ini
