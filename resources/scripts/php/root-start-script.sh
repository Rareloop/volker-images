#!/bin/bash

echo "Running Root startup script";

echo "Running as: $(whoami)"

# Install composer
DEFAULT_COMPOSER_BRANCH="1"
COMPOSER_BRANCH="${COMPOSER_BRANCH:=${DEFAULT_COMPOSER_BRANCH}}"
PROJECT_TYPE='php';
if [ -f 'volker.json' ]; then
    PROJECT_TYPE=$(grep 'type' volker.json | sed "s/.*project_type\": \"\([a-zA-Z]*\)\".*/\1/g");
fi

echo "Running for project: $PROJECT_TYPE"

echo "Installing Composer version \"${COMPOSER_BRANCH}\""
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --$COMPOSER_BRANCH

# Add composer
# Don't evaluate variables so this is done in the bashrc
echo 'export PATH="$PATH:$HOME/.composer/vendor/bin"' >> /home/www/.bashrc
echo 'export PATH="$PATH:$HOME/.composer/vendor/bin"' >> /root/.bashrc

# Install additional PHP extensions
if [ -n "$PHP_EXTENSIONS" ]; then
    echo "Installing Extra PHP Extensions: ${PHP_EXTENSIONS}"
    install-php-extensions "${PHP_EXTENSIONS}"
fi

# Install WordPress CLI if a Wordpress project
if [[ "$PROJECT_TYPE" == "wordpress" ]]; then
    echo 'Installing Wordpress CLI';
    composer global require wp-cli/wp-cli-bundle
    echo 'Installed Wordpress CLI';
fi

if [ -f "/home/www/volker/app/Resources/global/certs/volker.test.crt" ]; then
    echo "Adding Volker CA.."
    cat /home/www/volker/app/Resources/global/certs/volker.test.crt >> /etc/ssl/certs/ca-certificates.crt
    cat /home/www/volker/app/Resources/global/ca_scripts/myCA.pem >> /etc/ssl/certs/ca-certificates.crt
fi

echo "Adding .vimrc";
echo "syntax on" >> /home/www/.vimrc;
