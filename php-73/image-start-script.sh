#!/bin/bash

COMPOSER_VERSION="${COMPOSER_VERSION:-1}"


# Install composer
echo 'Installing Composer..'
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --1