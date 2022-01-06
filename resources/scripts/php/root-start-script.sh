#!/bin/bash

echo "Running Root startup script";

echo "Running as: $(whoami)"

# Install composer
DEFAULT_COMPOSER_BRANCH="1"
COMPOSER_BRANCH="${COMPOSER_BRANCH:=${DEFAULT_COMPOSER_BRANCH}}"

echo "Installing Composer version \"${COMPOSER_BRANCH}\""
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --$COMPOSER_BRANCH

# Install additional PHP extensions
if [ -n "$PHP_EXTENSIONS" ]; then
    echo "Installing Extra PHP Extensions: ${PHP_EXTENSIONS}"
    install-php-extensions "${PHP_EXTENSIONS}"
fi

if [ -f "/home/www/volker/app/Resources/global/certs/volker.test.crt" ]; then
    echo "Adding Volker CA.."
    cat /home/www/volker/app/Resources/global/certs/volker.test.crt >> /etc/ssl/certs/ca-certificates.crt
    cat /home/www/volker/app/Resources/global/ca_scripts/myCA.pem >> /etc/ssl/certs/ca-certificates.crt
fi

echo "Adding .vimrc";
echo "syntax on" >> /home/www/.vimrc;
