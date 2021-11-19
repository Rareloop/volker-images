#!/bin/bash

echo 'Doing some image specific work when the container starts ...'

echo 'Checking for .nvmrc'
NODE_VERSION="$(sed "s/v//g" .nvmrc)"
echo "Found node $NODE_VERSION"
/bin/bash -l -c "nvm install $NODE_VERSION"
