#!/bin/bash
echo 'Container entrypoint'

echo "Running as: $(whoami)"

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

echo "Running command exec $*"
exec "$@"
