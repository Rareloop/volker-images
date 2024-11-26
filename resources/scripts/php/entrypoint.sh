#!/bin/bash
echo 'Container entrypoint'

echo "Running as: $(whoami)"

if [[ ! -z "${EXPERIMENTAL_SYNC_ENABLED}" ]]; then
    # Wait until the sync container has opened port 5001 signalling sync has finished
    until nc -z sync 5001; do
        echo "Sync has not finished yet - sleeping"
        sleep 1
    done
fi


# If we have a QA instance, delegate to the QA script 
if [[ ! -z "${QA_INSTANCE}" ]]; then
    echo "Inside QA instance $QA_INSTANCE, running qa-start-script.sh";
    sudo -E /docker-scripts/qa-start-script.sh
fi

if [ -f '/docker-scripts/root-start-script.sh' ]; then
    if [ -f '/docker-scripts/ran-root-start-script' ]; then
        echo 'Skipping root-start-script.sh'
    else
        echo 'Found root-start-script.sh to run'
        sudo -E /docker-scripts/root-start-script.sh
        sudo -E touch '/docker-scripts/ran-root-start-script'
    fi
fi

if [ -f '/docker-scripts/custom-root-script.sh' ]; then
    if [ -f '/docker-scripts/ran-custom-root-script' ]; then
        echo 'Skipping custom-root-script.sh'
    else
        echo 'Found custom-root-script.sh to run'
        sudo -E /docker-scripts/custom-root-script.sh
        sudo -E touch '/docker-scripts/ran-custom-root-script'
    fi
fi
if [ -f '/docker-scripts/www-start-script.sh' ]; then
    if [ -f '/docker-scripts/ran-www-start-script' ]; then
        echo 'Skipping www-start-script.sh'
    else
        echo 'Found www-start-script.sh to run'
        /docker-scripts/www-start-script.sh
        sudo -E touch '/docker-scripts/ran-www-start-script'
    fi
fi

if [ -f '/docker-scripts/custom-www-script.sh' ]; then
    if [ -f '/docker-scripts/ran-custom-www-script' ]; then
        echo 'Skipping custom-www-script.sh'
    else
        echo 'Found custom-www-script.sh to run'
        /docker-scripts/custom-www-script.sh
        sudo -E touch '/docker-scripts/ran-custom-www-script'
    fi
fi

# Look for these custom scripts /var/www/.volker/php too.
#
# This means the end user doesn't have to bind mount
# the script in with an override, it's a convention.
#
# We deliberately look in /php to open up the possibility of custom
# scripts for nginx etc later.
if [ -f '/var/www/.volker/php/custom-root-script.sh' ]; then
    echo 'Found custom-root-script.sh to run'
    sudo -E /var/www/.volker/php/custom-root-script.sh
    echo 'Done'
fi

if [ -f '/var/www/.volker/php/custom-www-script.sh' ]; then
    echo 'Found custom-www-script.sh to run'
    /var/www/.volker/php/custom-www-script.sh
    echo 'Done'
fi

# Detect if we have our own custom php.ini to apply
if [ -f '/var/www/.volker/php/php.ini' ]; then
    echo 'Found custom php.ini to apply'
    sudo cp /var/www/.volker/php/php.ini /usr/local/etc/php/conf.d/zzz-php.ini
    echo 'Done'
fi

echo "Running command exec $*"
exec "$@"
