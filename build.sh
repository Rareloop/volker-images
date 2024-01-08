#!/bin/bash
# Use this when wanting to manually build outside of CI.

PLATFORMS='linux/amd64'
IMAGES=(
    # 'nginx'
    # 'nginx-cors'
    # 'php-71'
    # 'php-72'
    # 'php-73'
    # 'php-74'
    'php-83'
    # 'php-82'
    # 'php-81'
    # 'php-80'
    # 'node-6'
    # 'node-8'
    # 'node-10'
    # 'node-11'
    # 'nvm'
)

docker buildx rm volkerbuilder > /dev/null 2>&1
docker buildx create --use --name=volkerbuilder > /dev/null 2>&1

# Build the images
for IMAGE in ${IMAGES[@]}; do
    (docker buildx build -f ${IMAGE}/DockerFile . -t rareloop-local/volker:${IMAGE} --platform ${PLATFORMS} --output=type=docker)
done

# Cleanup
docker buildx rm volkerbuilder
