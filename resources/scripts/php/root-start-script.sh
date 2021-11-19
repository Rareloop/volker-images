#!/bin/bash

echo "Running Root startup script";

echo "Running as: $(whoami)"

DEFAULT_BRANCH="1"

COMPOSER_BRANCH="${COMPOSER_BRANCH:=${DEFAULT_BRANCH}}"

# Install composer
echo "Installing Composer version \"${COMPOSER_BRANCH}\""
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --$COMPOSER_BRANCH