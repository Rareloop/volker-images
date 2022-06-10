#!/bin/sh

# If we were given a QA instance, restore that to /var/www
if [[ ! -z "${QA_INSTANCE}" ]]; then
    if [ -f "/qa/${QA_INSTANCE}.tar" ]; then
        echo "Restoring QA Instance: \"${QA_INSTANCE}\""
        tar -xf /qa/${QA_INSTANCE}.tar -C /

        cp /var/www/.env.qa /var/www/.env 
        echo 'Restored'
    fi
fi

# Generate the Nginx configuration using the configuration script
echo 'Generating Nginx Configuration';
/docker-scripts/generate-config.sh > /etc/nginx/conf.d/app.conf
echo 'Done';
