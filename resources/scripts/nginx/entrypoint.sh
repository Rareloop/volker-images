#!/bin/sh

if [[ ! -z "${QA_INSTANCE}" ]]; then
    if [ -f "/qa/${QA_INSTANCE}.tar" ]; then
        echo "Restoring QA Instance: \"${QA_INSTANCE}\""
        tar -xf /qa/${QA_INSTANCE}.tar -C /

        cp /var/www/.env.qa /var/www/.env 
        echo 'Restored'
    fi
fi

printenv

echo 'Generating Nginx Configuration';
# Write nginx config
/docker-scripts/generate-config.sh > /etc/nginx/conf.d/app.conf
cat /etc/nginx/conf.d/app.conf
echo 'Done';
