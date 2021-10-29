#!/bin/bash
echo 'Container entrypoint'

if [ -f '/image-start-script.sh' ]; then
    echo 'Found image image-start-script.sh to run'
    /image-start-script.sh
fi

if [ -f './custom-script.sh' ]; then
    echo 'Found project container-start-script.sh to run'
    ./container-start-script.sh
fi

echo 'Container entrypoint complete'

# Continue with the parent container CMD
/sbin/my_init
