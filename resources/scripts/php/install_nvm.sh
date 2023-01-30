#!/bin/bash

mkdir -p $NVM_DIR
sudo -H -u www bash -c "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh | bash"