#!/bin/bash

adduser -u 1000 -g 1000 -s /bin/bash www www
# groupadd -g 1000 www`
# useradd -u 1000 -ms /bin/bash -g www www`

# Add user to wheel group (sudo)
adduser www wheel

# Allow members of sudo to execute without a password
echo "%wheel ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/sudo