#!/bin/bash

curl -sSLf \
    -o /usr/local/bin/install-php-extensions \
    https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions && \
    chmod +x /usr/local/bin/install-php-extensions
    
apk add sudo
#     # locales \ FIGURE OUT
# apk add sudo \
#     build-base \
#     libpng-dev \
#     libjpeg-turbo-dev \
#     freetype-dev \
#     zip \
#     jpegoptim \
#     optipng \
#     pngquant \
#     gifsicle \
#     vim \
#     unzip \
#     git \
#     curl \
#     libzip-dev \
#     oniguruma-dev \
#     libxml2-dev \
#     yaml-dev \
#     libmagickwand-dev
# apt-get update && apt-get install -y \

# apt-get clean && rm -rf /var/lib/apt/lists/*