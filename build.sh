#!/bin/bash

# nginx
(cd nginx && docker build -f DockerFile . -t rareloop/volker:nginx && docker push rareloop/volker:nginx)

# nginx with cors support
(cd nginx-cors && docker build -f DockerFile . -t rareloop/volker:nginx-cors && docker push rareloop/volker:nginx-cors)

# php-71
(cd php-71 && docker build -f DockerFile . -t rareloop/volker:php-71 && docker push rareloop/volker:php-71)

# php-72
(cd php-72 && docker build -f DockerFile . -t rareloop/volker:php-72 && docker push rareloop/volker:php-72)

# php-73
(cd php-73 && docker build -f DockerFile . -t rareloop/volker:php-73 && docker push rareloop/volker:php-73)

# php-74
(cd php-74 && docker build -f DockerFile . -t rareloop/volker:php-74 && docker push rareloop/volker:php-74)

# node-6
(cd node-6 && docker build -f DockerFile . -t rareloop/volker:node-6 && docker push rareloop/volker:node-6)