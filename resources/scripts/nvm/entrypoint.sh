#!/bin/bash
echo 'Container entrypoint'

if [ -f '/image-start-script.sh' ]; then
    echo 'Found image image-start-script.sh to run'
    /image-start-script.sh
fi

if [ -f '/var/www/container-start-script.sh' ]; then
    echo 'Found project container-start-script.sh to run'
    /var/www/container-start-script.sh
fi

echo 'Container entrypoint complete'