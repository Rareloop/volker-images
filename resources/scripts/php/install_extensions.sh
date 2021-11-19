#!/bin/bash

docker-php-ext-install mysqli pdo_mysql mbstring zip exif pcntl soap
docker-php-ext-configure gd --with-gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/
docker-php-ext-install zip gd sockets opcache intl
pecl install redis && docker-php-ext-enable redis
pecl install imagick && docker-php-ext-enable imagick
pecl install yaml && docker-php-ext-enable yaml