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
    docker-php-ext-install ${PHP_EXTENSIONS}
fi