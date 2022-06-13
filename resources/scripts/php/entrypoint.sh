#!/bin/bash
echo 'Container entrypoint'

echo "Running as: $(whoami)"

if [[ ! -z "${EXPERIMENTAL_SYNC_ENABLED}" ]]; then
    until nc -z sync 5001; do
        echo "Sync has not finished yet - sleeping"
        sleep 1
    done
fi

if [ -f '/docker-scripts/root-start-script.sh' ]; then
    echo 'Found root-start-script.sh to run'
    sudo -E /docker-scripts/root-start-script.sh
fi

if [ -f '/docker-scripts/custom-root-script.sh' ]; then
    echo 'Found custom-root-script.sh to run'
    sudo -E /docker-scripts/custom-root-script.sh
fi

if [ -f '/docker-scripts/www-start-script.sh' ]; then
    echo 'Found www-start-script.sh to run'
    /docker-scripts/www-start-script.sh
fi

if [ -f '/docker-scripts/custom-www-script.sh' ]; then
    echo 'Found custom-www-script.sh to run'
    /docker-scripts/custom-www-script.sh
fi

echo "Running command exec $*"
exec "$@"
