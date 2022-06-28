#!/bin/bash

echo "Running QA startup script";

if [[ ! -z "${QA_INSTANCE}" ]]; then
    if [ -f "/qa/${QA_INSTANCE}.tar" ]; then
        echo "Restoring QA Instance Tar: \"${QA_INSTANCE}\""
        sudo tar -xf /qa/${QA_INSTANCE}.tar -C /

        echo 'Restored'
    fi

    # We have to determine the PROJECT_TYPE after the untar, as volker.json doesn't exist until now
    if [ -f 'volker.json' ]; then  
        PROJECT_TYPE=$(grep 'type' volker.json | sed "s/.*project_type\": \"\([a-zA-Z]*\)\".*/\1/g");
    fi

    echo "Restoring .env.qa"

    if [[ "$PROJECT_TYPE" == "laravel" ]]; then
        cp /var/www/.env.qa /var/www/.env 
    fi

    if [[ "$PROJECT_TYPE" == "wordpress" ]]; then
        cp /var/www/site/.env.qa /var/www/site/.env 
    fi

    echo 'Restored'
fi
