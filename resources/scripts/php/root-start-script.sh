#!/bin/bash

echo "Running Root startup script";

echo "Running as: $(whoami)"

# Install composer
DEFAULT_COMPOSER_BRANCH="1"
COMPOSER_BRANCH="${COMPOSER_BRANCH:=${DEFAULT_COMPOSER_BRANCH}}"
PROJECT_TYPE='php';
XDEBUG_ENABLED="${XDEBUG_ENABLED:=0}"
XDEBUG_PROFILER_ENABLED="${XDEBUG_PROFILER_ENABLED:=0}"

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

# Fix permissions for www users .config folder
chown -R www:www /home/www/.composer
chown -R www:www /home/www/.config

# Install additional PHP extensions
if [ -n "$PHP_EXTENSIONS" ]; then
    echo "Installing Extra PHP Extensions: ${PHP_EXTENSIONS}"
    install-php-extensions "${PHP_EXTENSIONS}"
fi


if [[ "$XDEBUG_ENABLED" == "1" ]]; then
    echo 'Installing XDebug';

    echo 'Installing the Extension'
    # Install the XDebug PHP extension
    install-php-extensions xdebug
    
    echo 'Installing the configuration'

    # Copy the XDebug PHP config over
    # If we've enabled profiling - copy the profiling .ini over, otherwise the regular version.
    if [[ "$XDEBUG_PROFILER_ENABLED" == "1" ]]; then
        echo 'Profiling Enabled';
        cp /docker-config/xdebug-profiling.ini /usr/local/etc/php/conf.d/xdebug.ini
    else
        echo 'Profiling Disabled';
        cp /docker-config/xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini
    fi  

    echo 'Installed XDebug';
fi

if [ -f "/home/www/.config/volker/certs/volker-ca.pem" ]; then
    echo "Adding Volker CA Cert.."
    cat /home/www/.config/volker/certs/volker-ca.pem >> /etc/ssl/certs/ca-certificates.crt
    echo "Adding Volker Project Cert.."
    cat /home/www/.config/volker/certs/volker.test.crt >> /etc/ssl/certs/ca-certificates.crt
fi

echo "Adding .vimrc";
echo "syntax on" >> /home/www/.vimrc;

# Using jq, fish the extra php extensions out of volker.json and install them
install_extensions_from_volker_json() {
    if [ ! -f '/var/www/volker.json' ]; then
        return 0;
    fi

    echo 'Attempting to install custom extensions'

    # Parse the extra extensions out of volker.json first
    extensions=$(jq -r '.extra_php_extensions | join(" ")' /var/www/volker.json)

    if [ $? -ne 0 ]; then
        echo "Failed to parse extra extensions out of JSON."

        return 1
    fi


    if [ -z "$extensions" ]; then
        echo "No extensions found to install."

        return 0;
    fi

    echo "Attempting to install extensions: '$extensions'"

    # Run the install-php-extensions command
    install-php-extensions $extensions
}

install_extensions_from_volker_json
