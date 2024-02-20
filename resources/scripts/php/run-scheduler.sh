#!/bin/bash

# Get the value of the ENV_VAR environment variable or use a default value
SCHEDULE_MINUTES=${INTERVAL_MINUTES}
COMMAND=${CRON_COMMAND}

if [[ "" == "${COMMAND}" ]]; then
    # Default to the laravel command for backward compatibility
    COMMAND="php /var/www/artisan schedule:run --verbose --no-interaction"
fi

if [[ "" == "${SCHEDULE_MINUTES}" ]]; then
    # Default to every minute
    SCHEDULE_MINUTES=1
fi

# Calculate seconds
SCHEDULE_SECONDS=$((SCHEDULE_MINUTES * 60))

echo "Running every ${SCHEDULE_MINUTES} minutes: ${COMMAND}"

while true
do
  ${COMMAND} &
  sleep ${SCHEDULE_SECONDS}
done
