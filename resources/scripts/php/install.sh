#!/bin/bash

# Common Script to run between PHP Dockerfiles to try and simplify them
source /docker-scripts/install_dependencies.sh
source /docker-scripts/install_users.sh
source /docker-scripts/install_extensions.sh
source /docker-scripts/install_config.sh

echo 'Installing Dependencies..'
install_dependencies 

echo 'Installing Users..'
install_users

echo 'Installing Extensions..'
install_extensions
