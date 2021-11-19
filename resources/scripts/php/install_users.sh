#!/bin/bash

groupadd -g 1000 www
useradd -u 1000 -ms /bin/bash -g www www

# Add user to sudo group
adduser www sudo

# Allow members of sudo to execute without a password
echo "%sudo ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/sudo