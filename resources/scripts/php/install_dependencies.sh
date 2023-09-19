#!/bin/bash

# Install the PHP extensions script, simplifies installing extension dependencie
curl -sSLf \
    -o /usr/local/bin/install-php-extensions \
    https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions && \
    chmod +x /usr/local/bin/install-php-extensions
    
# Install Sudo
apt-get update && apt-get install -y \
    sudo \
    vim \
    nano \
    netcat-traditional \
    git \
    iputils-ping \
    dnsutils \
    default-mysql-client

# Cleanup Apt
apt-get clean && rm -rf /var/lib/apt/lists/*

# Install WP CLI
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp