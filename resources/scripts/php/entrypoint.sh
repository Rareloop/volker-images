#!/bin/bash
echo 'Container entrypoint'

echo "Running as: $(whoami)"

if [ -f '/docker-scripts/root-start-script.sh' ]; then
    echo 'Found root-start-script.sh to run'
    sudo -E /docker-scripts/root-start-script.sh
fi

if [ -f '/docker-scripts/www-start-script.sh' ]; then
    echo 'Found www-start-script.sh to run'
    /docker-scripts/www-start-script.sh
fi

echo "Running command exec $*"
exec "$@"