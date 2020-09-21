#!/bin/bash

# nginx
(cd nginx && docker build -f DockerFile . -t tomb1n0/volker-images:nginx && docker push tomb1n0/volker-images:nginx)

# nginx with cors support
(cd nginx-cors && docker build -f DockerFile . -t tomb1n0/volker-images:nginx-cors && docker push tomb1n0/volker-images:nginx-cors)

# php-71
(cd php-71 && docker build -f DockerFile . -t tomb1n0/volker-images:php-71 && docker push tomb1n0/volker-images:php-71)

# php-73
(cd php-73 && docker build -f DockerFile . -t tomb1n0/volker-images:php-73 && docker push tomb1n0/volker-images:php-73)

# php-74
(cd php-74 && docker build -f DockerFile . -t tomb1n0/volker-images:php-74 && docker push tomb1n0/volker-images:php-74)