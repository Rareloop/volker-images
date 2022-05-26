#!/bin/bash

echo "Running www startup script";

PROJECT_TYPE='php';

if [ -f 'volker.json' ]; then
    PROJECT_TYPE=$(grep 'type' volker.json | sed "s/.*project_type\": \"\([a-zA-Z]*\)\".*/\1/g");
fi

echo "Running for project: $PROJECT_TYPE"

echo "Running as: $(whoami)"