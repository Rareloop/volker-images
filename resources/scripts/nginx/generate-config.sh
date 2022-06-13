#!/bin/bash

# Be explicit about which variables we're expecting
DOCUMENT_ROOT=${DOCUMENT_ROOT}
APP_URL=${APP_URL}
SHARED_URL=${SHARED_URL}
CORS_ENABLED=${CORS_ENABLED}

if [[ -n "${CORS_OVERRIDE}" ]]; then
    CORS_ENABLED=1
fi

# Start server section
envsubst <<EOF
server {
    listen 80;
    index index.php index.html;
    error_log /var/log/nginx/error.log;
    access_log /var/log/nginx/access.log;
    root /var/www/${DOCUMENT_ROOT};
EOF
if [[ "$CORS_ENABLED" == "1" ]]; then
cat <<EOF
    add_header 'Access-Control-Allow-Origin' '*' always;
    add_header 'Access-Control-Allow-Methods' 'GET, POST, PUT, PATCH, OPTIONS, DELETE';
    add_header 'Access-Control-Allow-Headers' 'DNT,Origin,X-Device-UUID,X-Device-Version,X-Device-PLatform,X-Device-Model,X-Auth-Token,X-Requested-With,Content-Type,If-Modified-Since,User-Agent,Keep-Alive,Content-Length,Accept,Cache-Control,X-Upload-Content-Length,X-Upload-Content-Type,Authorization';
    add_header 'Access-Control-Expose-Headers' 'X-Location';
EOF
fi

# Location ~ \.php files
cat <<EOF

    location ~ \.php$ {
        try_files \$uri =404;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass app:9000;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        fastcgi_param PATH_INFO \$fastcgi_path_info;
EOF
if [[ "$CORS_ENABLED" == "1" ]]; then
cat <<EOF
        add_header 'Access-Control-Allow-Origin' '*' always;
        add_header 'Access-Control-Allow-Methods' 'GET, POST, PUT, PATCH, OPTIONS, DELETE';
        add_header 'Access-Control-Allow-Headers' 'DNT,Origin,X-Device-UUID,X-Device-Version,X-Device-PLatform,X-Device-Model,X-Auth-Token,X-Requested-With,Content-Type,If-Modified-Since,User-Agent,Keep-Alive,Content-Length,Accept,Cache-Control,X-Upload-Content-Length,X-Upload-Content-Type,Authorization';
        add_header 'Access-Control-Expose-Headers' 'X-Location';
EOF
fi
if [[ -n "${SHARED_URL}" ]]; then
envsubst <<EOF
        sub_filter ${APP_URL} ${SHARED_URL};";
        sub_filter_once off;";
EOF
fi
cat <<EOF
    }
EOF

# Location / files
cat <<EOF

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;";
        gzip_static on;";
EOF
if [[ "$CORS_ENABLED" == "1" ]]; then
cat <<EOF
        if (\$request_method = 'OPTIONS') {
            # Tell client that this pre-flight info is valid for 20 days
            add_header 'Access-Control-Allow-Origin' '*';
            add_header 'Access-Control-Allow-Methods' 'GET, POST, PUT, PATCH, OPTIONS, DELETE';
            add_header 'Access-Control-Allow-Headers' 'DNT,Origin,X-Auth-Token,X-Device-UUID,X-Device-Version,X-Device-PLatform,X-Device-Model,X-Requested-With,Content-Type,If-Modified-Since,User-Agent,Keep-Alive,Content-Length,Accept,Cache-Control,X-Upload-Content-Length,X-Upload-Content-Type,Authorization';
            add_header 'Access-Control-Expose-Headers' 'X-Location';
            # add_header 'Access-Control-Max-Age' 1728000;
            add_header 'Content-Type' 'text/plain charset=UTF-8';
            add_header 'Content-Length' 0;
            return 204;
        }
EOF
fi
if [[ -n "${SHARED_URL}" ]]; then
envsubst <<EOF
        sub_filter ${APP_URL} ${SHARED_URL};";
        sub_filter_once off;";
EOF
fi
cat <<EOF
    }
EOF

# End server section
cat <<EOF
}
EOF
