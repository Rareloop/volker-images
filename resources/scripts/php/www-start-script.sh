#!/bin/bash

echo "Running www startup script";

PROJECT_TYPE='php';

if [ -f 'volker.json' ]; then
    PROJECT_TYPE=$(grep 'type' volker.json | sed "s/.*project_type\": \"\([a-zA-Z]*\)\".*/\1/g");
fi

echo "Running for project: $PROJECT_TYPE"


# Install WordPress CLI if a Wordpress project
if [[ "$PROJECT_TYPE" == "wordpress" ]]; then
    echo 'Installing Wordpress CLI';
    composer global require wp-cli/wp-cli-bundle
    echo 'Installed Wordpress CLI';
fi

echo "Running as: $(whoami)"