#!/bin/sh

# Be explicit about which variables we're expecting
DOCUMENT_ROOT=${DOCUMENT_ROOT}
APP_URL=${APP_URL}
SHARED_URL=${SHARED_URL}
CORS_ENABLED=${CORS_ENABLED}

# Render the template itself
# This is pretty dumb but i don't know a better way of rendering a template out like this and making use of conditionals in a nice way
echo "server {";
echo "    listen 80;";
echo "    index index.php index.html;";
echo "    error_log  /var/log/nginx/error.log;";
echo "    access_log /var/log/nginx/access.log;";
echo "    root /var/www/${DOCUMENT_ROOT};";
echo "";
if [[ "$CORS_ENABLED" == "1" ]]; then
echo "    add_header 'Access-Control-Allow-Origin' '*' always;";
echo "    add_header 'Access-Control-Allow-Methods' 'GET, POST, PUT, PATCH, OPTIONS, DELETE';";
echo "    add_header 'Access-Control-Allow-Headers' 'DNT,Origin,X-Device-UUID,X-Device-Version,X-Device-PLatform,X-Device-Model,X-Auth-Token,X-Requested-With,Content-Type,If-Modified-Since,User-Agent,Keep-Alive,Content-Length,Accept,Cache-Control,X-Upload-Content-Length,X-Upload-Content-Type,Authorization';";
echo "    add_header 'Access-Control-Expose-Headers' 'X-Location';";
echo "";
fi
echo "    location ~ \.php$ {";
if [[ "$CORS_ENABLED" == "1" ]]; then
echo "        add_header 'Access-Control-Allow-Origin' '*' always;";
echo "        add_header 'Access-Control-Allow-Methods' 'GET, POST, PUT, PATCH, OPTIONS, DELETE';";
echo "        add_header 'Access-Control-Allow-Headers' 'DNT,Origin,X-Device-UUID,X-Device-Version,X-Device-PLatform,X-Device-Model,X-Auth-Token,X-Requested-With,Content-Type,If-Modified-Since,User-Agent,Keep-Alive,Content-Length,Accept,Cache-Control,X-Upload-Content-Length,X-Upload-Content-Type,Authorization';";
echo "        add_header 'Access-Control-Expose-Headers' 'X-Location';";
echo "";
fi
echo "        try_files \$uri =404;";
echo "        fastcgi_split_path_info ^(.+\.php)(/.+)$;";
echo "        fastcgi_pass app:9000;";
echo "        fastcgi_index index.php;";
echo "        include fastcgi_params;";
echo "        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;";
echo "        fastcgi_param PATH_INFO \$fastcgi_path_info;";
if [[ ! -z "${SHARED_URL}" ]]; then
echo "        sub_filter ${APP_URL} ${SHARED_URL};";
echo "        sub_filter_once off;";
fi
echo "    }";
echo "";
echo "    location / {";
if [[ "$CORS_ENABLED" == "1" ]]; then
echo "    if (\$request_method = 'OPTIONS') {";
echo "        # Tell client that this pre-flight info is valid for 20 days";
echo "        add_header 'Access-Control-Allow-Origin' '*';";
echo "        add_header 'Access-Control-Allow-Methods' 'GET, POST, PUT, PATCH, OPTIONS, DELETE';";
echo "        add_header 'Access-Control-Allow-Headers' 'DNT,Origin,X-Auth-Token,X-Device-UUID,X-Device-Version,X-Device-PLatform,X-Device-Model,X-Requested-With,Content-Type,If-Modified-Since,User-Agent,Keep-Alive,Content-Length,Accept,Cache-Control,X-Upload-Content-Length,X-Upload-Content-Type,Authorization';";
echo "        add_header 'Access-Control-Expose-Headers' 'X-Location';";
echo "        # add_header 'Access-Control-Max-Age' 1728000;";
echo "        add_header 'Content-Type' 'text/plain charset=UTF-8';";
echo "        add_header 'Content-Length' 0;";
echo "        return 204;";
echo "    }";
echo "";
fi
echo "        try_files \$uri \$uri/ /index.php?\$query_string;";
echo "        gzip_static on;";
if [[ ! -z "${SHARED_URL}" ]]; then
echo "        sub_filter ${APP_URL} ${SHARED_URL};";
echo "        sub_filter_once off;";
fi
echo "    }";
echo "}";
