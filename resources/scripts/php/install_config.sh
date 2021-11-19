#!/bin/bash

# Copy Opcache configuration
cp /docker-config/opcache.ini /usr/local/etc/php/conf.d/opcache.ini

# Setup PHP FPM workers config
{
    echo 'pm = dynamic';
    echo 'pm.max_children = 5';
    echo 'pm.start_servers = 2';
    echo 'pm.min_spare_servers = 1';
    echo 'pm.max_spare_servers = 3';
} >> /usr/local/etc/php-fpm.d/zz-docker.conf