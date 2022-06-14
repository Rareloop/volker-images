#!/bin/sh

if [[ ! -z "${EXPERIMENTAL_SYNC_ENABLED}" ]]; then
    # Wait until the sync container has opened port 5001 signalling sync has finished
    until nc -z sync 5001; do
        echo "Sync has not finished yet - sleeping"
        sleep 1
    done
fi

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
sh /docker-scripts/generate-config.sh > /root/app.conf
mv /root/app.conf /etc/nginx/conf.d/app.conf
echo 'Done';

echo 'Signalling Reload to Nginx..'
nginx -s reload

echo 'Finished'