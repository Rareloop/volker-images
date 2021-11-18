#!/bin/bash
echo 'Container entrypoint'

echo 'Running as:'
whoami

if [ -f '/image-start-script.sh' ]; then
    echo 'Found image image-start-script.sh to run'
    /image-start-script.sh
fi

exec "$@"