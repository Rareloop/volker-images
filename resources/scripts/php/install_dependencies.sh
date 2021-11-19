#!/bin/bash

apt-get update && apt-get install -y \
    sudo \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    curl \
    libzip-dev \
    libonig-dev \
    libxml2-dev \
    libyaml-dev \
    libmagickwand-dev

apt-get clean && rm -rf /var/lib/apt/lists/*